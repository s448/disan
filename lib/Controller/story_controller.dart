import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Core/enum/media_types.dart';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Model/story_model.dart';
import 'package:disan/Service/uploda_file_to_firebase.dart';
import 'package:disan/View/Screens/navbar/timeline/story/add_story.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class StoryManageController extends GetxController {
  final FileUploader _uploader = FileUploader();
  final _picker = ImagePicker();
  final userController = Get.find<UserController>();
  var file = Rx<XFile?>(null);

  RxString caption = ''.obs;
  RxBool storyUploading = false.obs;
  final uuid = const Uuid();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var permissionGranted = false.obs;
  //get stories

  /// 1 get all stories
  /// 2 sort stories and group them
  /// 3 return list<List<story>>

  _getStories() async {
    try {
      final currentTime = DateTime.now();
      final twentyFourHoursAgo =
          currentTime.subtract(const Duration(hours: 24));

      final querySnapshot = await _firestore
          .collection('story')
          .where('date', isGreaterThan: twentyFourHoursAgo)
          .orderBy('date', descending: true)
          .get();
      final List<Story> stories = querySnapshot.docs.map((doc) {
        print(doc);
        return Story.fromJson(doc.data());
      }).toList();
      return stories;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  ///every item of the return of this method is a list named after the user id
  ///who shared this story
  Future<List<List<Story>>> getGroupOfStories() async {
    try {
      var stories = await _getStories();
      // print("storeis before grouping ================" + stories);
      // Create a map to store the grouped stories
      Map<String, List<Story>> groupedStories = {};

      // Iterate over the list of stories
      for (var story in stories) {
        // Check if the user already has a list of stories
        if (groupedStories.containsKey(story.user!.id)) {
          // Add the current story to the existing list
          groupedStories[story.user!.id]!.add(story);
        } else {
          // Create a new list for the user and add the current story
          groupedStories[story.user!.id!] = [story];
        }
      }

      // Convert the map values to a list
      List<List<Story>> result = groupedStories.values.toList();

      return result;
    } catch (e) {
      print("Error 87 87 87 87 87 7");
      print(e);
      return [];
    }
  }

  //add story

  /// 1 pick the images and put them into list of XFILE
  /// 2 upload the media one by one and save the link of every one to the list of URLs
  /// 3 upload the story model to firestore
  var mediaType = Rx<MediaType?>(null);

  void setMedia(XFile pickedFile) {
    file.value = pickedFile;
    final isImage = pickedFile.path.endsWith('.jpg') ||
        pickedFile.path.endsWith('.png') ||
        pickedFile.path.endsWith('.jpeg');
    final isVideo = pickedFile.path.endsWith('.mp4');

    if (isImage) {
      mediaType.value = MediaType.image;
    } else if (isVideo) {
      mediaType.value = MediaType.video;
    }
  }

  // getMediaType(String url) {

  // }

  Future<void> pickStoryMedia() async {
    if (await isLimitReached()) {
      customSnackbar("You have reached tha daily limit".tr, "");
    } else {
      await requestPermissions();
      if (permissionGranted.value == true) {
        try {
          file.value = await _picker.pickMedia();
          setMedia(file.value!);
          Get.to(() => MediaViewerPage());
        } on Exception catch (e) {
          print(e);
        }
      } else {
        dangerSnackbar("Permissions for Camera & Gallery required".tr,
            "please allow Disan to use them".tr);
      }
    }
  }

  uploadStory() async {
    storyUploading.value = true;
    String storyId = uuid.v1();
    try {
      var imgLink = await _uploader.uploadFile(file.value, "story");
      Story story = Story(
        date: Timestamp.now(),
        user: userController.curentUserModel,
        img: imgLink,
        id: storyId,
        caption: caption.value,
        isVideo: mediaType.value == MediaType.image ? false : true,
      );
      await _firestore.collection('story').doc(storyId).set(story.toJson());
      storyUploading.value = false;
      update();
      Get.back();
      return true;
    } catch (e) {
      dangerSnackbar("cannot save the Story".tr, e.toString());
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

  isLimitReached() async {
    List<Story> stories = await _getStories();
    if (stories.length > 3) {
      return true;
    } else {
      return false;
    }
  }

  //delete story
}
