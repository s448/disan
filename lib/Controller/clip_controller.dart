import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Controller/user_controller.dart';
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
    print(reels);
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
  List<ReelModel> reels = [];
  getClips() async {
    try {
      final querySnapshot = await _firestore
          .collection('clip')
          .orderBy('date', descending: true)
          .get();
      final List<ClipModel> clips = querySnapshot.docs.map((doc) {
        return ClipModel.fromJson(doc.data());
      }).toList();
      for (var clip in clips) {
        reels.add(
          ReelModel(
            id: clip.id,
            clip.media ?? "",
            clip.user!.name ?? "",
            profileUrl: clip.user!.profile,
            reelDescription: clip.caption,
            likeCount: clip.likers!.length,
            isLiked: clip.likers!.contains(userController.curentUserModel.id),
            musicName: '',
            commentList: <ReelCommentModel>[
              for (var comment in clip.comments!)
                ReelCommentModel(
                  comment: comment.comment ?? "",
                  userProfilePic: comment.user!.profile ?? "",
                  userName: comment.user!.name ?? "",
                  commentTime: comment.date!.toDate(),
                )
            ],
          ),
        );
        print(clips);
      }
    } catch (e) {
      print(e);
    }
  }

  //clip state getters
  getReelByUrl(url) => reels.firstWhere((element) => element.url == url);
  getReelByIndex(index) => reels[index];
  likeReel() async {
    try {
      ReelModel reel = getReelByIndex(reelIndex.value);
      String clipId = reel.id ?? "";
      var result = await _firestore.collection('clip').doc(clipId).get();

      ClipModel clip = ClipModel.fromJson(result.data()!);

      if (clip.likers!.contains(userController.userModel.id)) {
        clip.likers!.remove(userController.userModel.id!);
        reels[reelIndex.value].likeCount--;
        reels[reelIndex.value].isLiked = false;
        print("remove like--------");
        update();
      } else {
        clip.likers!.add(userController.userModel.id!);
        reels[reelIndex.value].likeCount++;
        reels[reelIndex.value].isLiked = true;
        print("add like------------");
        update();
      }
      await _firestore.collection("clip").doc(clipId).update(clip.toJson());
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
        reels[reelIndex.value].commentList!.add(
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

  getLikesCount(index) => reels[index].likeCount;
  getLikeStatus(index) => reels[index].isLiked;
  getCommentsCount(index) => reels[index].commentList!.length;
  getComments(index) => reels[index].commentList;
}
