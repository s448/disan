import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Model/comment_model.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:disan/Model/notification_model.dart';
import 'package:disan/Service/audio_recorder.dart';
import 'package:disan/Service/fcm_services.dart';
import 'package:disan/Service/firebase_services.dart';
import 'package:disan/Service/uploda_file_to_firebase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:toast/toast.dart';

class TimelineTapController extends GetxController {
  final FileUploader _imageUploader = FileUploader();
  final uuid = const Uuid();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FcmServices _fcm = FcmServices();
  final FirebaseServices _firebaseServices = FirebaseServices();

  final recorder = AudioRecordService();
  RxBool isRecording = false.obs;
  RxBool withRecord = false.obs;
  RxString recordLink = "".obs;
  final userController = Get.find<UserController>();

  var permissionGranted = false.obs;
  RxBool postButtonUploading = false.obs;
  final _picker = ImagePicker();
  RxList<XFile>? images = RxList<XFile>();

  File? recordFile;

  TextEditingController commentController = TextEditingController();
  RxString description = "".obs;
  RxString comment = "".obs;
  RxList<String> imgLinks = RxList();

  Future<void> pickMultipleImages() async {
    // List<Asset> resultList = <Asset>[];
    await requestPermissions();
    if (permissionGranted.value == true) {
      try {
        images!.value = await _picker.pickMultiImage();
        images!.value = images!.getRange(0, 3).toList();
      } on Exception catch (e) {
        log(e.toString());
      }
      for (var element in images ?? []) {
        log(element);
      }

      // if (resultList.isNotEmpty) {
      //   selectedImages = resultList;
      //   // print(selectedImages);
      // }
    } else {
      dangerSnackbar("Permissions for Camera & Gallery required".tr,
          "please allow Disan to use them".tr);
    }
  }

  requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.camera,
    ].request();

    if (statuses[Permission.camera]!.isGranted) {
      permissionGranted.value = true;
    } else {
      permissionGranted.value = false;
    }
    update();
  }

  createPost() async {
    postButtonUploading.value = true;
    try {
      if (withRecord.value) {
        recordLink.value =
            await _imageUploader.uploadFile(XFile(recordFile!.path), "voice");
      }
      // ignore: invalid_use_of_protected_member
      for (var photo in images?.value ?? []) {
        var link = await _imageUploader.uploadFile(photo, "images");
        imgLinks.add(link);
      }
      print(imgLinks);
      if (await uploadPost()) {
        images?.clear();
        Get.back();
        Get.back();
        customSnackbar("Post uploaded successfully".tr, "");
      }

      postButtonUploading.value = false;
    } catch (e) {
      postButtonUploading.value = false;
      // print(e);
    }
  }

  uploadPost() async {
    String postId = uuid.v1();
    // print(postId);
    try {
      DanModel dan = DanModel(
        id: postId,
        comments: [],
        date: Timestamp.now(),
        description: withRecord.value ? recordLink.value : description.value,
        // ignore: invalid_use_of_protected_member
        imgs: imgLinks.value,
        likes: 0,
        likers: [],
        raters: [],
        rating: 0.0,
        withRecord: withRecord.value,
        user: userController.curentUserModel,
        isReDaned: false,
        reDanner: null,
      );

      await _firestore.collection('posts').doc(postId).set(dan.toJson());
      return true;
    } catch (e) {
      dangerSnackbar("cannot save the post".tr, e.toString());
      print(e);
      return false;
    }
  }

  redanPost(DanModel dan) async {
    String postId = uuid.v1();

    try {
      dan.isReDaned = true;
      dan.reDanner = userController.curentUserModel;
      await _firestore.collection('posts').doc(postId).set(dan.toJson());
      customSnackbar("You shared the dan".tr, "");
      return true;
    } catch (e) {
      dangerSnackbar("cannot redan the post".tr, e.toString());
      print(e);
      return false;
    }
  }

  startRecording() async {
    // print("start record");
    withRecord.value = true;
    isRecording.value = true;
    update();
    await recorder.initRecorder();
    await recorder.record();
  }

  RxBool hasRecord = false.obs;
  stopRecording() async {
    // print("stop record");
    isRecording.value = false;
    recordFile = await recorder.stop();
    hasRecord.value = true;
    Toast.show("Record saved".tr);
    update();
    // print("the file from controller >>>>> $recordLink");
  }

  deleteRecord() async {
    // print("Delete record");
    await recordFile!.delete();
  }

  Stream<List<DanModel>> getTimelinePosts() {
    final currentTime = DateTime.now();
    final fifteenDaysAgo = currentTime.subtract(const Duration(days: 15));
    return _firestore
        .collection('posts')
        .orderBy('date', descending: true)
        .where('date', isGreaterThan: fifteenDaysAgo)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return DanModel.fromJson(data);
      }).toList();
    });
  }

  Future<void> addCommentToPost(String postId) async {
    try {
      if (comment.value.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({
          'comments': FieldValue.arrayUnion([
            Comment(
              comment: comment.value,
              date: Timestamp.now(),
              user: userController.curentUserModel,
            ).toJson(),
          ])
        });
      }
      //get the post
      var result = await _firestore.collection('posts').doc(postId).get();
      DanModel danModel = DanModel.fromJson(result.data()!);
      await notifyPostOwner(
          danModel,
          "comment",
          "New comment".tr,
          "${userController.curentUserModel.name} " "commented on your post"
              .tr);
    } catch (e) {
      print(e);
      dangerSnackbar("Cannot add the comment".tr, "".tr);
    }
  }

  RxBool liked = false.obs;

  likePost(String postId) async {
    try {
      var result = await _firestore.collection('posts').doc(postId).get();

      DanModel danModel = DanModel.fromJson(result.data()!);

      print(danModel.id);

      if (danModel.likers!.contains(userController.userModel.id)) {
        danModel.likes = (danModel.likes! - 1);
        danModel.likers!.remove(userController.userModel.id!);
        update();
      } else {
        danModel.likes = danModel.likes! + 1;
        danModel.likers!.add(userController.userModel.id!);
        update();
      }
      await _firestore
          .collection("posts")
          .doc(postId)
          .update(danModel.toJson());
      liked.value = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  RxDouble rate = 0.0.obs;

  ratePost(String postId) async {
    try {
      var result = await _firestore.collection('posts').doc(postId).get();

      DanModel danModel = DanModel.fromJson(result.data()!);

      if (danModel.raters!.contains(userController.userModel.id)) {
        customSnackbar("You rated this Dan before".tr, "");
        return;
      } else {
        var currentRating = danModel.rating ?? 0.0;
        var totalRaters = danModel.raters!.length + 1;
        var totalRating = (rate.value + currentRating) / totalRaters;
        danModel.raters!.add(userController.userModel.id!);
        danModel.rating = totalRating;

        danModel.ratesCount = danModel.ratesCount ?? 0 + 1;
      }
      await _firestore
          .collection("posts")
          .doc(postId)
          .update(danModel.toJson());
      await notifyPostOwner(
        danModel,
        "rate",
        "New rating".tr,
        "${userController.curentUserModel.name} " "rated your product".tr,
      );
      customSnackbar("Rating is applied", "");
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  notifyPostOwner(
      DanModel dan, String topic, String notTitle, String notBody) async {
    String docid = const Uuid().v1();
    String title = notTitle;
    String body = notBody;
    //send a notification to the publisher
    await _fcm.sendNotification(dan.user!.token!, title, body);
    NotificationModel notificationModel = NotificationModel(
      id: docid,
      body: body,
      title: title,
      dan: dan,
      date: Timestamp.now(),
      topic: topic,
      user: userController.curentUserModel,
    );
    //save the notification on firestore
    await _firebaseServices.saveNotificationToFirebase(notificationModel);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getPost(String postId) {
    return _firestore.collection('posts').doc(postId).snapshots();
  }
}
