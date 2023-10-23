import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:disan/Service/uploda_file_to_firebase.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class TimelineTapController extends GetxController {
  final ImageUploader _imageUploader = ImageUploader();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final uuid = const Uuid();

  final userController = Get.find<UserController>();

  List<Asset> selectedImages = <Asset>[];
  var permissionGranted = false.obs;
  RxBool postButtonUploading = false.obs;
  final _picker = ImagePicker();
  RxList<XFile>? images = RxList<XFile>();

  RxString description = "".obs;

  RxList<String> imgLinks = RxList();

  Future<void> pickMultipleImages() async {
    List<Asset> resultList = <Asset>[];
    await requestPermissions();
    // selectedImages.clear();
    if (permissionGranted.value == true) {
      try {
        images!.value = await _picker.pickMultiImage();
        // resultList = await MultiImagePicker.pickImages(
        //   maxImages: 3,
        //   enableCamera: true,
        //   selectedAssets: selectedImages,
        // );
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
        description: description.value,
        imgs: imgLinks.value,
        likes: 0,
        rating: 0.0,
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
}
