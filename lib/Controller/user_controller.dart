import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

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
    print("Current user is ====> \n");
    print(curentUserModel.toJson());
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
}
