import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser;
  UserModel userModel = UserModel();
  UserModel curentUserModel = UserModel();

  @override
  void onInit() async {
    currentUser = _auth.currentUser;
    curentUserModel = await getUserModel(currentUser!.uid).first;
    log("Current user is ====> \n");
    log(curentUserModel.toJson().toString());
    super.onInit();
  }

  Stream<UserModel> getUserModel(String userId) {
    var result = _firestore.collection('users').doc(userId).snapshots();
    return result.map((snapshot) {
      if (snapshot.exists) {
        userModel = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
        return userModel;
      } else {
        return UserModel();
      }
    });
  }

  follow(String? userId) async {
    try {
      final myUserId = currentUser!.uid;

      // Update the other user's list of followers
      await _firestore.collection('users').doc(userId).update({
        'followers': FieldValue.arrayUnion([myUserId]),
      });

      // Update the current user's list of following
      await _firestore.collection('users').doc(myUserId).update({
        'following': FieldValue.arrayUnion([userId]),
      });

      customSnackbar("you are following him".tr, "");
    } catch (error) {
      print('Error following user: $error');
    }
  }

  mute(String? userId) async {
    try {
      final myUserId = currentUser!.uid;

      // Update the current user's list of following
      await _firestore.collection('users').doc(myUserId).update({
        'muted': FieldValue.arrayUnion([userId]),
      });
      customSnackbar("user is muted".tr, "");
    } catch (error) {
      print('Error muting user: $error');
    }
  }

  block(String? userId) async {
    try {
      final myUserId = currentUser!.uid;

      // Update the current user's list of following
      await _firestore.collection('users').doc(myUserId).update({
        'blocked': FieldValue.arrayUnion([userId]),
      });
      customSnackbar("user is blocked".tr, "");
    } catch (error) {
      log('Error blocking user: $error');
    }
  }

  save(List<String> imgs) async {
    final status = await Permission.storage.request();

    if (status != PermissionStatus.granted) {
      dangerSnackbar("Microphone permission not granted".tr, "");
      return;
    }
    try {
      for (var img in imgs) {
        var response = await Dio()
            .get(img, options: Options(responseType: ResponseType.bytes));
        final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name: const Uuid().v1(),
        );
        customSnackbar("Post images was saved to gallery", "");
        log(result);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  delete(String? postId, String collection) async {
    try {
      // delete the post
      await _firestore.collection(collection).doc(postId).delete();
      customSnackbar("item is deleted".tr, "");
    } catch (error) {
      log('Error deleteing item: $error');
    }
  }

  makePopupAction(String ex, String userId, String postId, List<String> imgs,
      collection) async {
    switch (ex) {
      case "1":
        await save(imgs);
        break;
      case "2":
        await follow(userId);
        break;
      case "3":
        await mute(userId);
        break;
      case "4":
        await block(userId);
        break;
      case "5":
        await delete(postId, collection);
        break;
      default:
    }
  }
}
