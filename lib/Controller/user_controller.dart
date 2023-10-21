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
    userModel = await getCurrentUserModel();
    print(userModel.toJson());
    super.onInit();
  }

  getCurrentUserModel() async {
    var result =
        await _firestore.collection('users').doc(currentUser!.uid).get();
    return UserModel.fromJson(result.data()!);
  }
}
