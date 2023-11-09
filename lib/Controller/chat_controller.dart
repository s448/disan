import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Core/extension/url_launch_service.dart';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:disan/Model/notification_model.dart';
import 'package:disan/Model/user_model.dart';
import 'package:disan/Service/fcm_services.dart';
import 'package:disan/Service/firebase_services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  @override
  void onInit() {
    isUserRegisterd();
    super.onInit();
  }

  RxBool hidePhone = false.obs;
  RxString phone = "".obs;
  RxBool userRegisterd = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userController = Get.find<UserController>();

  final FcmServices _fcm = FcmServices();
  final FirebaseServices _firebaseServices = FirebaseServices();

  flipHideCheckBox() => hidePhone.value = !hidePhone.value;
  isUserRegisterd() {
    var wa = userController.curentUserModel.whatsappNumber;
    if (wa == null || wa == "") {
      userRegisterd.value = false;
    } else {
      userRegisterd.value = true;
    }
    update();
  }

  registerChat() async {
    try {
      var userId = userController.curentUserModel.id;

      await _firestore.collection('users').doc(userId).update({
        "phone": phone.value,
        "wahiden": hidePhone.value,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  allowUserToChatWithMe(String? userId) async {
    try {
      var myUserId = userController.curentUserModel.id;

      await _firestore.collection('users').doc(myUserId).update({
        'waallowed': FieldValue.arrayUnion([userId]),
      });
      customSnackbar("Chat request is accepted".tr, "");
    } catch (error) {
      log('Error blocking user: $error');
    }
  }

  amIAllowedToContactHim(UserModel user) {
    if (user.waHiden == true) {
      if (user.waAllowed!.contains(userController.curentUserModel.id)) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  Future<List<UserModel>> getOtherRegisteredUsers() async {
    List<UserModel> users = [];
    // var myUserId = userController.curentUserModel.id;

    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .where('whatsapp', isNotEqualTo: "")
        .where('whatsapp', isNotEqualTo: null)
        .get();
    print(snapshot.docs.length);
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      UserModel user = UserModel.fromJson(doc.data());
      users.add(user);
    }

    return users;
  }

  makeContactAction(UserModel user) async {
    if (user.waHiden == false) {
      UrlLauncherService.launch(
          'https://api.whatsapp.com/send?phone=${user.whatsappNumber}&text=${Uri.encodeComponent("")}');
    } else {
      if (user.waAllowed!.contains(userController.curentUserModel.id)) {
        UrlLauncherService.launch(
            'https://api.whatsapp.com/send?phone=${user.whatsappNumber}&text=${Uri.encodeComponent("")}');
      } else {
        requestConnection(user);
      }
    }
  }

  requestConnection(UserModel user) async {
    try {
      String docid = const Uuid().v1();
      String title = "Connection request".tr;
      String body = user.name.toString() + " wants to contact with you".tr;
      await _fcm.sendNotification(user.token!, title, body);
      NotificationModel notificationModel = NotificationModel(
        id: docid,
        body: body,
        title: title,
        dan: DanModel(likers: [], raters: [], user: user),
        date: Timestamp.now(),
        topic: "connection",
        user: userController.curentUserModel,
      );
      //save the notification on firestore
      await _firebaseServices.saveNotificationToFirebase(notificationModel);
      customSnackbar("Connection is sent to".tr + user.name.toString(),
          "we will let you know if he accepted it".tr);
    } catch (e) {
      dangerSnackbar("Cannot send request", e.toString());
      log(e.toString());
    }
  }
}
