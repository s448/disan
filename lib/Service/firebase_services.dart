import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  updateDocument(String collection, String docId, String jsonEncoded) async {
    try {
      var value = jsonDecode(jsonEncoded);
      print("Firestore services >>>>>> $value");
      await _firestore.collection(collection).doc(docId).set(value);
      return true;
    } catch (e) {
      return false;
    }
  }
}
