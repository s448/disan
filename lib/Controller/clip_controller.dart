// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Core/ultis/share.dart';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Model/clip_model.dart';
import 'package:disan/Model/comment_model.dart';
import 'package:disan/Service/uploda_file_to_firebase.dart';
import 'package:disan/View/Screens/navbar/clip/add_clip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class ClipController extends GetxController {
  @override
  void onInit() async {
    getClips();
    super.onInit();
  }

  final FileUploader _uploader = FileUploader();
  final _picker = ImagePicker();
  final userController = Get.find<UserController>();
  var file = Rx<XFile?>(null);

  RxString caption = ''.obs;
  RxBool storyUploading = false.obs;
  final uuid = const Uuid();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var permissionGranted = false.obs;

  //add clip

  Future<void> pickClipMedia() async {
    await requestPermissions();
    if (permissionGranted.value == true) {
      try {
        file.value = await _picker.pickVideo(source: ImageSource.gallery);
        Get.to(() => AddClipPage());
      } on Exception catch (e) {
        log(e.toString());
      }
    } else {
      dangerSnackbar(
        "Permissions for Camera & Gallery required".tr,
        "please allow Disan to use them".tr,
      );
    }
  }

  uploadClip() async {
    storyUploading.value = true;
    String clipId = uuid.v1();
    try {
      var videoLink = await _uploader.uploadFile(file.value, "clip");
      ClipModel clip = ClipModel(
        caption: caption.value,
        comments: [],
        date: Timestamp.now(),
        id: clipId,
        media: videoLink,
        user: userController.curentUserModel,
      );
      await _firestore.collection('clip').doc(clipId).set(clip.toJson());
      storyUploading.value = false;
      update();
      Get.back();

      return true;
    } catch (e) {
      dangerSnackbar("cannot save the Clip".tr, e.toString());
      print(e);
      storyUploading.value = false;
      update();
      Get.back();
      return false;
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

  //get clips

  Stream<List<ClipModel>> getClips() {
    final currentTime = DateTime.now();
    final fiveDaysAgo = currentTime.subtract(const Duration(days: 5));
    return _firestore
        .collection('clip')
        .orderBy('date', descending: true)
        .where('date', isGreaterThan: fiveDaysAgo)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return ClipModel.fromJson(data);
      }).toList();
    });
  }

  // getReelByIndex(index) => reels.value[index];
  RxBool isLiked = false.obs;
  likeReel(String clipId) async {
    isLiked.value = !isLiked.value;
    try {
      var result = await _firestore.collection('clip').doc(clipId).get();

      ClipModel clip = ClipModel.fromJson(result.data()!);

      if (clip.likers!.contains(userController.userModel.id)) {
        clip.likers!.remove(userController.userModel.id!);
        log("remove like--------");
        update();
      } else {
        clip.likers!.add(userController.userModel.id!);
        print("add like------------");
        update();
      }
      await _firestore.collection("clip").doc(clipId).update(clip.toJson());
      getClips();
    } catch (e) {
      log(e.toString());
    }
  }

  RxInt reelIndex = 0.obs;
  changeIndex(index) {
    reelIndex.value = index;
    update();
  }

  TextEditingController commentController = TextEditingController();
  RxString comment = "".obs;
  addComment(String clipId) async {
    try {
      if (comment.isNotEmpty) {
        await FirebaseFirestore.instance.collection('clip').doc(clipId).update({
          'comments': FieldValue.arrayUnion([
            Comment(
              comment: comment.value,
              date: Timestamp.now(),
              user: userController.curentUserModel,
            ).toJson(),
          ])
        });
        update();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  shareReel(reelDescription, url) async {
    try {
      await ShareService.shareSomething(
        reelDescription,
        '',
        url,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  isMe(userId) {
    if (userController.curentUserModel.id == userId) {
      return true;
    } else {
      return false;
    }
  }

  followUser(String userId) async {
    await userController.follow(userId);
    customSnackbar("You are following this user", "");
  }

  // getFollowStatus(uid) async {
  //   var res = await _firestore.collection('users').where('id', isEqualTo: uid).get();
  //   if (userController.curentUserModel.followers.contains(res.docs.)) {
  //   } else {}
  // }
  // getLikesCount(index) => reels[index].likeCount;
  // getLikeStatus(index) => reels[index].isLiked;
  // getCommentsCount(index) => reels[index].commentList!.length;
  // getComments(index) => reels[index].commentList;
}
