import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Model/comment_model.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:disan/Service/audio_recorder.dart';
import 'package:disan/Service/uploda_file_to_firebase.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:toast/toast.dart';

class TimelineTapController extends GetxController {
  final ImageUploader _imageUploader = ImageUploader();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final uuid = const Uuid();

  final recorder = AudioRecordService();
  RxBool isRecording = false.obs;
  RxBool withRecord = false.obs;
  RxString recordLink = "".obs;
  final userController = Get.find<UserController>();

  List<Asset> selectedImages = <Asset>[];
  var permissionGranted = false.obs;
  RxBool postButtonUploading = false.obs;
  final _picker = ImagePicker();
  RxList<XFile>? images = RxList<XFile>();

  File? recordFile;

  RxString description = "".obs;
  RxString comment = "".obs;
  RxList<String> imgLinks = RxList();

  Future<void> pickMultipleImages() async {
    List<Asset> resultList = <Asset>[];
    await requestPermissions();
    // selectedImages.clear();
    if (permissionGranted.value == true) {
      try {
        images!.value = await _picker.pickMultiImage();
        images!.value = images!.getRange(0, 3).toList();
      } on Exception catch (e) {
        print(e);
      }

      if (resultList.isNotEmpty) {
        selectedImages = resultList;
        print(selectedImages);
      }
    } else {
      dangerSnackbar("Permissions for Camera & Gallery required".tr,
          "please allow Disan to use them");
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
            await _imageUploader.uploadImage(XFile(recordFile!.path));
      }
      // ignore: invalid_use_of_protected_member
      for (var photo in images?.value ?? []) {
        var link = await _imageUploader.uploadImage(photo);
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
      print(e);
    }
  }

  uploadPost() async {
    String postId = uuid.v1();
    print(postId);
    try {
      DanModel userModel = DanModel(
        id: postId,
        comments: [],
        date: Timestamp.now(),
        description: withRecord.value ? recordLink.value : description.value,
        // ignore: invalid_use_of_protected_member
        imgs: imgLinks.value,
        likes: 0,
        rating: 0.0,
        withRecord: withRecord.value,
        user: userController.curentUserModel,
      );

      await _firestore.collection('posts').doc(postId).set(userModel.toJson());
      return true;
    } catch (e) {
      dangerSnackbar("cannot save the post".tr, e.toString());
      print(e);
      return false;
    }
  }

  startRecording() async {
    print("start record");

    withRecord.value = true;
    isRecording.value = true;
    update();
    await recorder.initRecorder();
    await recorder.record();
  }

  RxBool hasRecord = false.obs;
  stopRecording() async {
    print("stop record");
    isRecording.value = false;
    recordFile = await recorder.stop();
    hasRecord.value = true;
    Toast.show("Record saved".tr);
    update();
    print("the file from controller >>>>> $recordLink");
  }

  deleteRecord() async {
    print("Delete record");
    await recordFile!.delete();
  }

  Stream<List<DanModel>> getTimelinePosts() {
    return _firestore
        .collection('posts')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return DanModel.fromJson(data);
      }).toList();
    });
  }

  updatePost() async {}

  Future<void> addCommentToPost(String postId) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'comments': FieldValue.arrayUnion([
          Comment(
            comment: comment.value,
            date: Timestamp.now(),
            user: userController.curentUserModel,
          ).toJson(),
        ])
      });
      customSnackbar("Your comment was sent", '');
    } catch (e) {
      print(e);
      dangerSnackbar(
          "Cannot add the comment".tr, "check your internet connection".tr);
    }
  }
}
