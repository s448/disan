import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Model/notification_model.dart';
import 'package:disan/Model/order_model.dart';

class FirebaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // updateDocument(String collection, String docId, String jsonEncoded) async {
  //   try {
  //     var value = jsonDecode(jsonEncoded);
  //     print("Firestore services >>>>>> $value");
  //     await _firestore.collection(collection).doc(docId).set(value);
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<void> saveNotificationToFirebase(
      NotificationModel notification) async {
    try {
      // Save the notification to Firebase Realtime Database
      // notification.order = order;
      await _firestore
          .collection('notifications')
          .doc(notification.id)
          .set(notification.toJson());

      print('Notification saved to Firebase');
    } catch (error) {
      print('Error saving notification to Firebase: $error');
    }
  }

  Future<void> saveOrderToFirebase(OrderModel order) async {
    try {
      await _firestore.collection('orders').doc(order.id).set(order.toJson());

      print('Order saved to Firebase');
    } catch (error) {
      print('Error saving Order to Firebase: $error');
    }
  }
}
