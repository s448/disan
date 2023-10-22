import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser;
  UserModel userModel = UserModel();
  @override
  void onInit() async {
    currentUser = _auth.currentUser;
    // userModel = getUserModel(currentUser!.uid);
    print(userModel.toJson());
    super.onInit();
  }

  Stream<dynamic> getUserModel(String userId) {
    var result = _firestore.collection('users').doc(userId).snapshots();
    return result;
  }
}
