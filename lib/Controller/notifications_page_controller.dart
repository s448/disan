import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:disan/Model/notification_model.dart';
import 'package:disan/Model/order_model.dart';
import 'package:get/get.dart';

class NotificationsPageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userController = Get.find<UserController>();

  //get the common notifications
  Stream<List<NotificationModel>> getNotifications() {
    return _firestore
        .collection('notifications')
        .where(
          'dan.user.id',
          isEqualTo: userController.curentUserModel.id,
        )
        .where('topic', isEqualTo: 'comment')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return NotificationModel.fromJson(data);
      }).toList();
    });
  }

  //get order requests
  Stream<List<OrderModel>> getOrderNotifications() {
    return _firestore
        .collection('orders')
        .where(
          'dan.user.id',
          isEqualTo: userController.curentUserModel.id,
        )
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return OrderModel.fromJson(data);
      }).toList();
    });
  }

  Stream<List<DanModel>> getMyPosts() {
    return _firestore
        .collection('posts')
        .where(
          'user.id',
          isEqualTo: userController.curentUserModel.id,
        )
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return DanModel.fromJson(data);
      }).toList();
    });
  }

  //get rating notifications
  // Stream<List<NotificationModel>> getRatingNotifications() {
  //   return _firestore
  //       .collection('notifications')
  //       .where(
  //         'dan.user.id',
  //         isEqualTo: userController.curentUserModel.id,
  //       )
  //       .where('topic', isEqualTo: 'rate')
  //       .orderBy('date', descending: true)
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       Map<String, dynamic> data = doc.data();
  //       return NotificationModel.fromJson(data);
  //     }).toList();
  //   });
  // }
  //delete order

  //delete notification
}
