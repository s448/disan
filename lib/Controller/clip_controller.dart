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
import 'package:disan/View/Screens/navbar/timeline/clip/add_clip.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reels_viewer/reels_viewer.dart';
import 'package:uuid/uuid.dart';

class ClipController extends GetxController {
  @override
  void onInit() async {
    await getClips();
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
        print(e);
      }
    } else {
      dangerSnackbar("Permissions for Camera & Gallery required".tr,
          "please allow Disan to use them".tr);
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
  final reels = RxList<ReelModel>();
  // Stream<List<ClipModel>> getClips() {
  //   try {
  //     final querySnapshot =
  //         _firestore.collection('clip').orderBy('date', descending: true).get();
  //     final clips = querySnapshot.docs.map((doc) {
  //       return ClipModel.fromJson(doc.data());
  //     }).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Stream<List<ClipModel>> getClips() {
    return _firestore
        .collection('clip')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return ClipModel.fromJson(data);
      }).toList();
    });
  }

  //clip state getters
  // getReelByUrl(url) => reels.value.firstWhere((element) => element.url == url);
  getReelByIndex(index) => reels.value[index];
  likeReel() async {
    try {
      ReelModel reel = getReelByIndex(reelIndex.value);
      String clipId = reel.id ?? "";
      var result = await _firestore.collection('clip').doc(clipId).get();

      ClipModel clip = ClipModel.fromJson(result.data()!);

      if (clip.likers!.contains(userController.userModel.id)) {
        clip.likers!.remove(userController.userModel.id!);
        reels.value[reelIndex.value].likeCount--;
        reels.value[reelIndex.value].isLiked == false;
        print(reels.value[reelIndex.value].isLiked);
        print("remove like--------");
        update();
      } else {
        clip.likers!.add(userController.userModel.id!);
        reels.value[reelIndex.value].isLiked == true;
        print(reels.value[reelIndex.value].isLiked);

        reels.value[reelIndex.value].likeCount++;
        print("add like------------");
        update();
      }
      await _firestore.collection("clip").doc(clipId).update(clip.toJson());
      await getClips();
    } catch (e) {
      log(e.toString());
    }
  }

  RxInt reelIndex = 0.obs;
  changeIndex(index) {
    reelIndex.value = index;
    update();
  }

  addComment(String comment) async {
    try {
      ReelModel reel = getReelByIndex(reelIndex.value);
      String clipId = reel.id ?? "";

      if (comment.isNotEmpty) {
        await FirebaseFirestore.instance.collection('clip').doc(clipId).update({
          'comments': FieldValue.arrayUnion([
            Comment(
              comment: comment,
              date: Timestamp.now(),
              user: userController.curentUserModel,
            ).toJson(),
          ])
        });
        reels.value[reelIndex.value].commentList!.add(
          ReelCommentModel(
            comment: comment,
            userProfilePic: userController.curentUserModel.profile ?? "",
            userName: userController.curentUserModel.name ?? "",
            commentTime: DateTime.now(),
          ),
        );
        update();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // Stream<List<ReelModel>> getClipsStream() async* {
  //   final streamController = StreamController<List<ReelModel>>();

  //   try {
  //     final querySnapshot = await _firestore
  //         .collection('clip')
  //         .orderBy('date', descending: true)
  //         .get();
  //     final List<ClipModel> clips = querySnapshot.docs.map((doc) {
  //       return ClipModel.fromJson(doc.data());
  //     }).toList();

  //     final List<ReelModel> reelModels = clips.map((clip) {
  //       return ReelModel(
  //         id: clip.id,
  //         clip.media ?? "",
  //         clip.user!.name ?? "",
  //         profileUrl: clip.user!.profile,
  //         reelDescription: clip.caption,
  //         likeCount: clip.likers!.length,
  //         isLiked: clip.likers!.contains(userController.curentUserModel.id),
  //         musicName: null,
  //         commentList: clip.comments?.map((comment) {
  //               return ReelCommentModel(
  //                 comment: comment.comment ?? "",
  //                 userProfilePic: comment.user!.profile ?? "",
  //                 userName: comment.user!.name ?? "",
  //                 commentTime: comment.date?.toDate() ?? DateTime.now(),
  //               );
  //             })?.toList() ??
  //             <ReelCommentModel>[],
  //       );
  //     }).toList();

  //     streamController.add(reelModels);
  //     streamController.close();
  //   } catch (e) {
  //     streamController.addError(e);
  //   }

  //   yield* streamController.stream;
  // }

  shareReel() {
    ShareService.shareSomething(
      reels.value[reelIndex.value].userName,
      reels.value[reelIndex.value].reelDescription,
      reels.value[reelIndex.value].url,
    );
  }

  followUser() async {
    // userController.follow(
    //   clip.value[reelIndex.value].,
    // );
  }

  // getLikesCount(index) => reels[index].likeCount;
  // getLikeStatus(index) => reels[index].isLiked;
  // getCommentsCount(index) => reels[index].commentList!.length;
  // getComments(index) => reels[index].commentList;
}
