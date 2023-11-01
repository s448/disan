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

class StoryController extends GetxController {
  final FileUploader _uploader = FileUploader();
  final _picker = ImagePicker();
  final userController = Get.find<UserController>();
  // RxList<XFile>? images = RxList<XFile>();
  // RxList<String> imgLinks = RxList();
  // XFile? media;
  var file = Rx<XFile?>(null);

  RxString caption = ''.obs;
  RxBool storyUploading = false.obs;
  final uuid = const Uuid();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List<Asset> selectedImages = <Asset>[];
  var permissionGranted = false.obs;
  //get stories

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

  Future<void> pickStoryMedia() async {
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

  //delete story
}
