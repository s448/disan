// ignore_for_file: invalid_use_of_protected_member

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Core/constants/shop_categories.dart';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Model/user_model.dart';
import 'package:disan/Service/uploda_file_to_firebase.dart';
import 'package:disan/routes.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  final userModel = Get.put(UserController()).curentUserModel;
  @override
  void onInit() {
    name.value = userModel.name ?? "";
    whatsappNumber.value = userModel.whatsappNumber ?? "";
    hideWa.value = userModel.waHiden ?? false;
    bio.value = userModel.bio ?? "";
    locationLat.value = userModel.lat ?? 0.0;
    locationLng.value = userModel.long ?? 0.0;
    profilePicUrl.value = userModel.profile ?? "";
    backgroundPicUrl.value = userModel.background ?? "";
    for (var element in userModel.categories ?? []) {
      selectedCategories.value.add(element);
    }
    print(selectedCategories.value);
    print(whatsappNumber.value);
    super.onInit();
  }

  var name = "".obs;
  RxString accType = "USER".obs;
  var whatsappNumber = "".obs;
  RxBool hideWa = false.obs;
  RxString bio = "".obs;
  RxDouble locationLat = 0.0.obs;
  RxDouble locationLng = 0.0.obs;
  var profilePicUrl = "".obs;
  var backgroundPicUrl = "".obs;

  final _picker = ImagePicker();
  final _filePicker = FileUploader();

  RxList<String> selectedCategories = <String>[].obs;
  RxList<String> shopCategories = shopCatList.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final UserModel oldUser = Get.arguments['user'];

  RxBool saveButtonLoading = false.obs;
  updateUserInfo(String userId) async {
    saveButtonLoading.value = true;
    try {
      var userData = UserModel(
        name: name.value,
        profile: profilePicUrl.value,
        background: backgroundPicUrl.value,
        whatsappNumber: whatsappNumber.value,
        waHiden: hideWa.value,
        lat: locationLat.value,
        long: locationLng.value,
        bio: bio.value,
        categories: selectedCategories,
        blocked: oldUser.blocked,
        email: oldUser.email,
        followers: oldUser.followers,
        following: oldUser.following,
        id: oldUser.id,
        muted: oldUser.muted,
        raters: oldUser.raters,
        rating: oldUser.rating,
        token: oldUser.token,
        type: oldUser.type,
        waAllowed: oldUser.waAllowed,
      );
      await _firestore
          .collection("users")
          .doc(userId)
          .update(userData.toJson());
      saveButtonLoading.value = false;
      update();
      Get.offAllNamed(Routes.navbar);
      customSnackbar("Information saved".tr, "");
    } catch (e) {
      log(e.toString());
      saveButtonLoading.value = false;
      update();
      Get.offAllNamed(Routes.navbar);
    }
  }

  flipHideCheckBox() {
    hideWa.value = !hideWa.value;
  }

  addCatItem(val) {
    if (!selectedCategories.contains(val)) {
      selectedCategories.value = val;
      // print("selected");
    }
    update();
    // print(selectedCategories);
  }

  selectProfilePic() async {
    try {
      var pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      profilePicUrl.value = await _filePicker.uploadFile(pickedFile, "images");
    } catch (e) {
      dangerSnackbar("Failed to upload picture".tr, e.toString());
    }
  }

  selectBackgroundPic() async {
    try {
      var pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      backgroundPicUrl.value =
          await _filePicker.uploadFile(pickedFile, "images");
    } catch (e) {
      dangerSnackbar("Failed to upload picture".tr, e.toString());
    }
  }
}
