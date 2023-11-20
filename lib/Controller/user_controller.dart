// ignore_for_file: invalid_use_of_protected_member

import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Controller/local_storage.dart';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Model/clip_model.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:disan/Model/story_model.dart';
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
  final prefs = Get.find<SharedPrefsController>();

  @override
  void onInit() async {
    currentUser = _auth.currentUser;
    curentUserModel = await getUserModel(currentUser?.uid ?? "").first;
    log("current user is >>>>>>>>>>>>>." + curentUserModel.toString());
    await getMyActiveDans(curentUserModel.id.toString());
    await fetchBlockedUsers();
    ever(
      blockedUsers,
      (callback) => fetchBlockedUsers(),
    );
    super.onInit();
  }

  initUser() async {
    curentUserModel = await getUserModel(prefs.getItem("userId")).first;
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

  updateUserData() async {
    try {
      var result =
          await _firestore.collection('users').doc(curentUserModel.id).get();
      curentUserModel = UserModel.fromJson(result.data() ?? {});
    } catch (e) {
      log(e.toString());
    }
  }

  followunfollow(String? userId) async {
    try {
      final myUserId = currentUser!.uid;

      UserModel user = await getUserModel(userId ?? "").first;

      List<dynamic> followers = user.followers ?? [];
      // Update the other user's list of followers

      if (followers.contains(myUserId)) {
        //unfollow
        // Update the other user's list of followers
        await _firestore.collection('users').doc(userId).update({
          'followers': FieldValue.arrayRemove([myUserId]),
        });

        // Update the current user's list of following
        await _firestore.collection('users').doc(myUserId).update({
          'following': FieldValue.arrayRemove([userId]),
        });
        customSnackbar("You unfollowed him".tr, "");
      } else {
        //follow
        await _firestore.collection('users').doc(userId).update({
          'followers': FieldValue.arrayUnion([myUserId]),
        });

        // Update the current user's list of following
        await _firestore.collection('users').doc(myUserId).update({
          'following': FieldValue.arrayUnion([userId]),
        });
        customSnackbar("You are following him".tr, "");
      }
    } catch (error) {
      // print('Error following user: $error');
    }
  }

  isFollowing(List<dynamic> followList) {
    final myUserId = currentUser!.uid;

    if (followList.contains(myUserId)) {
      return true;
    } else {
      return false;
    }
  }

  // unfollow(String? userId) async {
  //   try {
  //     final myUserId = currentUser!.uid;

  //     // Update the other user's list of followers
  //     await _firestore.collection('users').doc(userId).update({
  //       'followers': FieldValue.arrayRemove([myUserId]),
  //     });

  //     // Update the current user's list of following
  //     await _firestore.collection('users').doc(myUserId).update({
  //       'following': FieldValue.arrayRemove([userId]),
  //     });

  //     customSnackbar("You are following him".tr, "");
  //   } catch (error) {
  //     // print('Error following user: $error');
  //   }
  // }

  mute(String? userId) async {
    try {
      final myUserId = currentUser!.uid;

      // Update the current user's list of following
      await _firestore.collection('users').doc(myUserId).update({
        'muted': FieldValue.arrayUnion([userId]),
      });
      customSnackbar("user is muted".tr, "");
    } catch (error) {
      // print('Error muting user: $error');
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

  save(List<dynamic> imgs) async {
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

  makePopupAction(String ex, String userId, String postId, List<dynamic> imgs,
      collection) async {
    switch (ex) {
      case "1":
        await save(imgs);
        break;
      case "2":
        await followunfollow(userId);
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

  // getMyFollowers() => curentUserModel.followers?.length ?? 0;
  // getMyFollowing() => curentUserModel.following?.length ?? 0;

  int activeDansLength = 0;
  List<DanModel> myActiveDans = [];
  Future<List<DanModel>> getMyActiveDans(String userId) async {
    try {
      final currentTime = DateTime.now();

      //the target date when the dan be unactive
      final fifteenDaysAgo = currentTime.subtract(const Duration(days: 15));

      var result = await _firestore
          .collection('posts')
          .where('user.id', isEqualTo: userId)
          .where('date', isGreaterThan: fifteenDaysAgo)
          .get();
      myActiveDans = result.docs.map((doc) {
        return DanModel.fromJson(doc.data());
      }).toList();
      activeDansLength = myActiveDans.length;
      return myActiveDans;
    } catch (e) {
      activeDansLength = 0;
      log(e.toString());
      return [];
    }
  }

  RxBool isListView = true.obs;
  changeActiveDansView() => isListView.value = !isListView.value;
  RxDouble rate = 0.0.obs;

  rateShop(String postId) async {
    try {
      var result = await _firestore.collection('users').doc(postId).get();

      UserModel shop = UserModel.fromJson(result.data()!);

      if (shop.raters!.contains(userModel.id)) {
        customSnackbar("You rated this Shop before".tr, "");
        return;
      } else {
        var currentRating = shop.rating ?? 0.0;
        var totalRaters = shop.raters!.length + 1;
        var totalRating = (rate.value + currentRating) / totalRaters;
        shop.raters!.add(userModel.id!);
        shop.rating = totalRating;
      }
      await _firestore.collection("users").doc(postId).update(shop.toJson());
      customSnackbar("Rating is applied", "");
      update();
    } catch (e) {
      log(e.toString());
    }
  }

  RxList<UserModel> blockedUsers = <UserModel>[].obs;

  fetchBlockedUsers() async {
    try {
      blockedUsers.value.clear();
      for (String userId in curentUserModel.blocked ?? []) {
        var userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          var item = UserModel.fromJson(userData);
          if (!blockedUsers.value.contains(item)) {
            blockedUsers.value.add(item);
          }
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> unblockUser(String userId) async {
    // Remove the user from the GetX controller list
    blockedUsers.value.removeWhere((user) => user.id == userId);
    update();
    // Get the current user's ID or any means to identify the current user
    String currentUserId = curentUserModel.id ??
        ""; // Replace with your actual logic to get the current user's ID

    // Reference to the current user's Firestore document
    DocumentReference currentUserDoc =
        _firestore.collection('users').doc(currentUserId);

    // Get the current user's "blocked" list from Firestore
    DocumentSnapshot currentUserSnapshot = await currentUserDoc.get();
    if (currentUserSnapshot.exists) {
      Map<String, dynamic> currentUserData =
          currentUserSnapshot.data() as Map<String, dynamic>;
      List<String> blockedList =
          List<String>.from(currentUserData['blocked'] ?? []);

      // Remove the user ID from the "blocked" list
      blockedList.remove(userId);

      // Update the "blocked" list in Firestore
      await currentUserDoc.update({'blocked': blockedList});
      await fetchBlockedUsers();
      // print("List after unblock >>>>>>>" + blockedList.toString());
    }
  }

  Future<List<ClipModel>> getMyActiveClips(String userId) async {
    final currentTime = DateTime.now();
    final fiveDaysAgo = currentTime.subtract(const Duration(days: 5));

    try {
      var result = await _firestore
          .collection('clip')
          .orderBy('date', descending: true)
          .where('user.id', isEqualTo: userId)
          .where('date', isGreaterThan: fiveDaysAgo)
          .get();

      final List<ClipModel> myClips = result.docs.map((doc) {
        return ClipModel.fromJson(doc.data());
      }).toList();
      return myClips;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<Story>> getMyActiveStories(String userId) async {
    final currentTime = DateTime.now();
    final twentyFourHoures = currentTime.subtract(const Duration(hours: 24));

    try {
      var result = await _firestore
          .collection('story')
          .orderBy('date', descending: true)
          .where('user.id', isEqualTo: userId)
          .where('date', isGreaterThan: twentyFourHoures)
          .get();

      final List<Story> myTales = result.docs.map((doc) {
        return Story.fromJson(doc.data());
      }).toList();
      return myTales;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
