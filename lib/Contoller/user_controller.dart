import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Service/uploda_file_to_firebase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserController extends GetxController {
  final _filePicker = ImageUploader();
  var name = ''.obs;
  var bio = ''.obs;
  var locationLat = 0.0.obs;
  var locationLng = 0.0.obs;
  var profilePicUrl = "".obs;
  var backgroundPicUrl = "".obs;

  final editInfoFormKey = GlobalKey<FormState>();

  selectProfilePic() async {
    try {
      profilePicUrl.value = await _filePicker.uploadImage();
    } catch (e) {
      dangerSnackbar("Error uploading".tr, e.toString());
    }
  }

  selectBackgroundPic() async {
    try {
      backgroundPicUrl.value = await _filePicker.uploadImage();
    } catch (e) {
      dangerSnackbar("Error uploading".tr, e.toString());
    }
  }

  LatLng selectedLocation = LatLng(0.0, 0.0);

  void selectLocation(LatLng location) {
    selectedLocation = location;
    update();
  }
}
