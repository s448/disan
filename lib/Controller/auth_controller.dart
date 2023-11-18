import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Controller/local_storage.dart';
import 'package:disan/Core/constants/shop_categories.dart';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Model/user_model.dart';
import 'package:disan/Service/fcm_services.dart';
import 'package:disan/Service/uploda_file_to_firebase.dart';
import 'package:disan/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AuthController extends GetxController {
  updateCurrentUserInfo() {
    name.value = _auth.currentUser!.displayName ?? name.value;
    email.value = _auth.currentUser!.email ?? email.value;
    profilePicUrl.value = _auth.currentUser!.photoURL ?? "";
    currUserId.value = _auth.currentUser!.uid;
    update();
  }

  final registerFormKey = GlobalKey<FormState>();
  final loginFormKey = GlobalKey<FormState>();
  final resetPasswordFormKey = GlobalKey<FormState>();

  final _filePicker = FileUploader();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _sharedPrefController =
      Get.put(SharedPrefsController(), permanent: true);

  final GoogleSignIn googleSignIn = GoogleSignIn();

  var uuid = const Uuid();
  var email = "".obs;
  var name = "".obs;
  var password = "".obs;
  var confirmPassword = "".obs;
  var rememberMe = false.obs;
  var textObsecured = true.obs;
  RxString accType = "USER".obs;
  var currUserId = ''.obs;

  var whatsappNumber = "".obs;
  RxBool hideWa = false.obs;
  RxString bio = "".obs;
  RxDouble locationLat = 0.0.obs;
  RxDouble locationLng = 0.0.obs;
  var profilePicUrl = "".obs;
  var backgroundPicUrl = "".obs;

  final _picker = ImagePicker();

  changeObscureTextStatus() {
    textObsecured.value = !textObsecured.value;
    update();
  }

  setAccountType(int? index) {
    index == 0 ? accType.value = "USER" : accType.value = "MERCHANT";
    update();
    print(accType.value.toString());
  }

  Future<bool> saveUserData() async {
    try {
      updateCurrentUserInfo();
      UserModel userModel = UserModel(
        email: email.value,
        name: name.value,
        profile: "",
        background: "",
        id: currUserId.value,
        type: accType.value,
        token: FcmServices().getToken(),
      );

      await _firestore
          .collection('users')
          .doc(currUserId.value)
          .set(userModel.toJson());
      return true;
    } catch (e) {
      dangerSnackbar("Cannot save user data".tr, e.toString());
      return false;
    }
  }

  createNewUser() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );
      if (isUserAuthenticated()) {
        if (rememberMe.value) {
          await _sharedPrefController.saveUserCredentials(
              credential.user!.uid, credential.user!.email!);
        }
        if (await saveUserData()) {
          customSnackbar("Register success".tr, "");
        }
        Get.offAllNamed(Routes.selectAccType);

        // print("auth success >>>>>>>>>>>>>>>>");
      } else {
        dangerSnackbar("Login error".tr, "");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        dangerSnackbar('The password provided is too weak'.tr, "");
        // print('The password provided is too weak'.tr);
      } else if (e.code == 'email-already-in-use') {
        dangerSnackbar('The account already exists for that email'.tr, "");
        // print('The account already exists for that email.');
      } else {
        dangerSnackbar('Register Error'.tr, e.toString());
      }
    } catch (e) {
      dangerSnackbar("Register error".tr, e.toString());
      // print(e);
    }
  }

  isUserAuthenticated() async {
    //if true then user authenticaed
    return await _auth.currentUser != null
        // && _sharedPrefController.userAuthenticated()
        ;
  }

  sendResetPasswordLink() async {
    var result = await _firestore
        .collection("users")
        .where("email", isEqualTo: email.value)
        .get();
    if (result.docs.isNotEmpty) {
      try {
        await _auth.sendPasswordResetEmail(email: email.value);
        Get.back();
        customSnackbar(
            "We sent a reset password link".tr, "Check your inbox".tr);
      } catch (e) {
        dangerSnackbar(
            "Operation failed".tr, "please check your internet connection".tr);
      }
    } else {
      dangerSnackbar("User with this email doesn't exist", "");
    }
  }

  signInWithEmailAndPassword() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.value, password: password.value);
      if (isUserAuthenticated()) {
        if (rememberMe.value) {
          await _sharedPrefController.saveUserCredentials(
              credential.user!.uid, credential.user!.email!);
        }
        customSnackbar("Login success".tr, "");
        // print("auth success >>>>>>>>>>>>>>>>");
        Get.offAllNamed(Routes.navbar);
      } else {
        dangerSnackbar("Login error", "");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        dangerSnackbar('No user found for that email'.tr, "");
        // print('No user found for that email'.tr);
      } else if (e.code == 'wrong-password') {
        dangerSnackbar('Wrong password provided for that user'.tr, "");
        // print('Wrong password provided for that user'.tr);
      } else {
        dangerSnackbar('Login Error'.tr, e.toString());
      }
    }
  }

  logout() async {
    try {
      await _auth.signOut();
      await _sharedPrefController.clearUserCredentials();
      Get.offAllNamed(Routes.login);
      customSnackbar(
        "Logout success".tr,
        '',
      );
    } catch (e) {
      log(e.toString());
    }
  }

  //google auth
  RxBool isGoogleLoading = false.obs;
  loginWithGoogle() async {
    isGoogleLoading.value = true;
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      final GoogleSignInAuthentication? googleSignInAuth =
          await googleSignInAccount?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuth?.accessToken,
        idToken: googleSignInAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;
      // print(">>>>>103 ${user?.displayName}");
      if (user != null) {
        await _sharedPrefController.saveUserCredentials(user.uid, user.email!);

        if (userCredential.additionalUserInfo!.isNewUser) {
          var userId = user.uid;
          try {
            UserModel userModel = UserModel(
              name: user.displayName,
              email: user.email,
              id: userId,
              type: accType.value,
              profile: user.photoURL,
              background: "",
              token: FcmServices().getToken(),
            );
            await _firestore
                .collection('users')
                .doc(userId)
                .set(userModel.toJson());

            // if (await userExist(user.email!)) {
            //   customSnackbar("Login success", "");
            // }
            isGoogleLoading.value = false;
            Get.offAllNamed(Routes.selectAccType);
          } catch (e) {
            // print("?????????can't save the user data");
            isGoogleLoading.value = false;
            dangerSnackbar("Login error", e.toString());
          }
        } else {
          isGoogleLoading.value = false;
          Get.offAllNamed(Routes.navbar);

          // print("user is already registerd >>>> login");
        }
        // print(">>>>>>user is set to shared prefs");
      }
    } catch (e) {
      // print(e);
      dangerSnackbar("Login error".tr, e.toString());
      isGoogleLoading.value = false;
    }
  }

  //facebook auth
  RxBool isFacebookLoading = false.obs;
  loginWithFacebook() async {
    isFacebookLoading.value = true;
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      final UserCredential userCredential =
          await _auth.signInWithCredential(facebookAuthCredential);
      // print("credentails ============ $facebookAuthCredential");
      // print("credentails ============ ${_auth.currentUser!.email}");
      final User user = userCredential.user!;

      if (facebookAuthCredential.accessToken == null) {
        isFacebookLoading.value = false;
        // print("176 >>>>>> credentials are null");
      } else {
        isFacebookLoading.value = false;
        // print(
        //     "the current user after fb auth: >>>>>${_auth.currentUser!.displayName}");
        await _sharedPrefController.saveUserCredentials(user.uid, user.email!);

        if (userCredential.additionalUserInfo!.isNewUser) {
          var userData = UserModel(
            email: user.email,
            id: user.uid,
            name: user.displayName,
            profile: user.photoURL,
            token: FcmServices().getToken(),
          );
          await _firestore
              .collection("users")
              .doc(user.uid)
              .set(userData.toJson());

          Get.offAllNamed(Routes.selectAccType);
        } else {
          Get.offAllNamed(Routes.navbar);
        }
      }
    } catch (e) {
      isFacebookLoading.value = false;
      dangerSnackbar("Login error".tr, e.toString());
    }
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

  flipHideCheckBox() {
    hideWa.value = !hideWa.value;
  }

  RxBool saveButtonLoading = false.obs;
  updateUserInfo() async {
    saveButtonLoading.value = true;
    try {
      var userData = UserModel(
        name: name.value,
        profile: profilePicUrl.value,
        background: backgroundPicUrl.value,
        type: accType.value,
        whatsappNumber: whatsappNumber.value,
        waHiden: hideWa.value,
        id: currUserId.value,
        email: email.value,
        lat: locationLat.value,
        long: locationLng.value,
        bio: bio.value,
        token: FcmServices().getToken(),
        // ignore: invalid_use_of_protected_member
        categories: selectedCategories.value,
      );
      await _firestore
          .collection("users")
          .doc(currUserId.value)
          .update(userData.toJson());
      saveButtonLoading.value = false;
      update();
      Get.offAllNamed(Routes.navbar);
      customSnackbar("Information saved".tr, "");
    } catch (e) {
      saveButtonLoading.value = false;
      // print("Errorrrrrrrrrrrr" + e.toString());
      update();
      Get.offAllNamed(Routes.navbar);
    }
  }

  //shop categories
  RxList<String> selectedCategories = <String>[].obs;
  RxList<String> shopCategories = shopCatList.obs;

  addCatItem(val) {
    if (!selectedCategories.contains(val)) {
      selectedCategories.value = val;
      // print("selected");
    }
    update();
    // print(selectedCategories);
  }
}
