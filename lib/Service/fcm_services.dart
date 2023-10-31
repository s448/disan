// import 'package:cityinpocket/Controller/shared_prefs_controller.dart';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Service/firebase_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

handleBackgroundMessage(RemoteMessage msg) async {
  // if (kDebugMode) {
  //   print("payload ==> ${msg.data}");
  //   print("Title ==> ${msg.notification?.title}");
  //   print("body ==> ${msg.notification?.body}");
  // }
}

class FcmServices {
  final userController = Get.find<UserController>();
  final _firebaseService = FirebaseServices();
  final _fcm = FirebaseMessaging.instance;
  static var _token = '';

  getToken() => _token;

  initNotification() async {
    await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final fcmToken = await _fcm.getToken();
    if (kDebugMode) {
      print(fcmToken);
    }
    _token = fcmToken ?? 'unknown';
    FirebaseMessaging.onBackgroundMessage(
        (message) => handleBackgroundMessage(message));
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      final Map<String, dynamic> data = event.data;
      if (kDebugMode) {
        print(data);
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // String docid = const Uuid().v1();
      // String title = message.notification?.title ?? '';
      // String body = message.notification?.body ?? '';
      // Timestamp date = Timestamp.now();

      // NotificationModel model = NotificationModel(
      //   id: docid,
      //   title: title,
      //   body: body,
      //   date: date,
      //   user: userController.curentUserModel,
      // );
      // if (title.toLowerCase().contains('comment')) {
      //   model.topic = "comment";
      //   await _firebaseService.saveNotificationToFirebase(model);
      // } else {
      //   model.topic = "rate";
      //   await _firebaseService.saveNotificationToFirebase(model);
      // }
    });
  }

  Future<void> sendNotification(
      String deviceToken, String title, String body) async {
    try {
      final dio = Dio();
      const url = 'https://fcm.googleapis.com/fcm/send';

      final headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAATPrH1wo:APA91bHGefLsTlwt8_hBpO95TsMLNOf0InDX6z20IC-qzAu-QM5wF3X_04F58ut64rHArZXJoUyS7aLu43Ctx0RUVOB1ZjIVgnzm3__6Uz8TH9PxKJL2CQZZY_tzRq4NqLNEMh_MuxY5',
      };

      final data = {
        'to': deviceToken,
        'notification': {
          'title': title,
          'body': body,
        },
      };

      final response = await dio.post(
        url,
        options: Options(headers: headers),
        data: jsonEncode(data),
      );

      print('Notification sent. Response: ${response.statusCode}');
    } catch (error) {
      print("in fcm page ========");
      print('Error sending notification: $error');
    }
  }
}
