import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Contoller/local_storage.dart';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Model/user_model.dart';
import 'package:disan/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

class AuthController extends GetxController {
  final registerFormKey = GlobalKey<FormState>();
  final loginFormKey = GlobalKey<FormState>();
  final resetPasswordFormKey = GlobalKey<FormState>();

  final _sharedPrefController =
      Get.put(SharedPrefsController(), permanent: true);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var uuid = const Uuid();
  var email = "".obs;
  var name = "".obs;
  var password = "".obs;
  var confirmPassword = "".obs;
  var rememberMe = false.obs;
  var textObsecured = true.obs;
  var type = "USER".obs;

  changeObscureTextStatus() {
    textObsecured.value = !textObsecured.value;
    update();
  }

  Future<bool> saveUserData() async {
    var userId = uuid.v1();
    try {
      UserModel userModel = UserModel(
        email: email.value,
        name: name.value,
        password: password.value,
        profile: "",
        background: "",
        id: userId,
        type: type.value,
      );

      await _firestore.collection('users').doc(userId).set(userModel.toJson());
      return true;
    } catch (e) {
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
        await _sharedPrefController.saveUserCredentials(
            credential.user!.uid, credential.user!.email!);
        saveUserData();
        customSnackbar("Register success".tr, "");

        print("auth success >>>>>>>>>>>>>>>>");
        Get.offAndToNamed(Routes.navbar);
      } else {
        dangerSnackbar("Login error".tr, "");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        dangerSnackbar('The password provided is too weak'.tr, "");
        print('The password provided is too weak'.tr);
      } else if (e.code == 'email-already-in-use') {
        dangerSnackbar('The account already exists for that email'.tr, "");
        print('The account already exists for that email.');
      } else {
        dangerSnackbar('Register Error'.tr, e.toString());
      }
    } catch (e) {
      dangerSnackbar("Register error".tr, e.toString());
      print(e);
    }
  }

  isUserAuthenticated() {
    //if true then user authenticaed
    return _auth.currentUser != null;
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
        await _sharedPrefController.saveUserCredentials(
            credential.user!.uid, credential.user!.email!);
        customSnackbar("Login success".tr, "");
        print("auth success >>>>>>>>>>>>>>>>");
        Get.offAndToNamed(Routes.navbar);
      } else {
        dangerSnackbar("Login error", "");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        dangerSnackbar('No user found for that email'.tr, "");
        print('No user found for that email'.tr);
      } else if (e.code == 'wrong-password') {
        dangerSnackbar('Wrong password provided for that user'.tr, "");
        print('Wrong password provided for that user'.tr);
      } else {
        dangerSnackbar('Login Error'.tr, e.toString());
      }
    }
  }

  logout() async {
    await _auth.signOut();
    _sharedPrefController.clearUserCredentials();
    Get.offAllNamed(Routes.login);
    customSnackbar(
      "Logout success".tr,
      '',
    );
  }

  Future<bool> userExist(String registerEmail) async {
    print("call user exist methode >>>>>>>>>>");
    try {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: registerEmail)
          .get();

      if (documentSnapshot.docs.isNotEmpty) {
        return true;
      } else {
        print('Document does not exist');
        return false;
      }
    } catch (e) {
      // Error occurred while searching for the document
      print('Error searching document: $e');
      return false;
    }
  }

  //google auth
  RxBool isGoogleLoading = false.obs;
  loginWithGoogle() async {
    isGoogleLoading.value = true;
    bool authSucceess = false;
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
      print(">>>>>103 ${user?.displayName}");
      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          var userId = user.uid;
          print(">>>>>>107 >>>>>new user");
          try {
            UserModel userModel = UserModel(
              name: user.displayName,
              email: user.email,
              id: userId,
              type: type.value,
              profile: "",
              background: "",
            );
            await _firestore
                .collection('users')
                .doc(userId)
                .set(userModel.toJson());

            if (await userExist(user.email!)) {
              authSucceess = true;
              customSnackbar("Login success", "");
            }
            isGoogleLoading.value = false;
          } catch (e) {
            print("?????????can't save the user data");
            isGoogleLoading.value = false;
            customSnackbar("Login rttot", e.toString());
          }
        } else {
          isGoogleLoading.value = false;
          authSucceess = true;
          print("user is already registerd >>>> login");
        }
        await _sharedPrefController.saveUserCredentials(user.uid, user.email!);
        // print(">>>>>>user is set to shared prefs");
      }
    } catch (e) {
      print(e);
      customSnackbar("Login error".tr, e.toString());
      isGoogleLoading.value = false;
      authSucceess = false;
    }
    if (authSucceess) {
      print("auth success >>>>>>>>>>>>>>>>");
      Get.offAndToNamed(Routes.navbar);
    }
  }

  Future<void> logoutGoogle() async {
    await googleSignIn.signOut();
    Get.offAllNamed(Routes.login);
  }

  //facebook auth
  RxBool isFacebookLoading = false.obs;
  loginWithFacebook() async {
    isFacebookLoading.value = true;
    bool authSucceess = false;
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      _auth.signInWithCredential(facebookAuthCredential);
      print("credentails ============ $facebookAuthCredential");
      print("credentails ============ ${_auth.currentUser!.email}");

      if (facebookAuthCredential.accessToken == null) {
        authSucceess = false;
        isFacebookLoading.value = false;
        print("176 >>>>>> credentials are null");
      } else {
        isFacebookLoading.value = false;
        authSucceess = true;
        await _sharedPrefController.saveUserCredentials(
            facebookAuthCredential.providerId, facebookAuthCredential.idToken!);
        print(
            "the current user after fb auth: >>>>>${_auth.currentUser!.displayName}");
        Get.toNamed(Routes.navbar);
      }
    } catch (e) {
      print(e.toString());
      isFacebookLoading.value = false;
      // dangerSnackbar("Error facebook login".tr, e.toString());
    }
    if (authSucceess) {
      print("auth success >>>>>>>>>>>>>>>>");
      Get.offAndToNamed(Routes.navbar);
    }
  }
}
