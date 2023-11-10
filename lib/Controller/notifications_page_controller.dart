import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:disan/Model/notification_model.dart';
import 'package:disan/Model/order_model.dart';
import 'package:disan/Model/user_model.dart';
import 'package:disan/Service/fcm_services.dart';
import 'package:get/get.dart';

class NotificationsPageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userController = Get.find<UserController>();
  final FcmServices _fcm = FcmServices();

  //get the common notifications
  Stream<List<NotificationModel>> getNotifications() {
    return _firestore
        .collection('notifications')
        .where(
          'dan.user.id',
          isEqualTo: userController.curentUserModel.id,
        )
        .where('topic', whereIn: ['comment', 'connection'])
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

  //delete notification
  deleteNotification(String docId) async {
    try {
      await _firestore.collection('notifications').doc(docId).delete();
    } catch (e) {
      dangerSnackbar("Cannot delete the notification", e.toString());
    }
  }

  acceptConnection(UserModel user, String docId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userController.curentUserModel.id)
          .update({
        'waallowed': FieldValue.arrayUnion([user.id]),
      });
      await deleteNotification(docId);
      customSnackbar("Request accepted".tr, "");
      await _fcm.sendNotification(
          user.token!,
          userController.curentUserModel.name.toString() +
              "accepted your request".tr,
          "".tr);
    } catch (e) {
      dangerSnackbar("Cannot accept connection request".tr, e.toString());
    }
  }
}
