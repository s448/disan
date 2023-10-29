import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:disan/Model/user_model.dart';
import 'package:get/get.dart';

class ShopTapController extends GetxController {
  @override
  void onInit() async {
    trendingProfiles.value = await getTrendingProfiles();
    bestSellingProducts.value = await getBestSelling();

    update();
    print("trending: =========>");
    print(trendingProfiles);
    print("bestselling: =========>");
    print(bestSellingProducts);
    super.onInit();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<UserModel> trendingProfiles = <UserModel>[].obs;
  RxList<DanModel> bestSellingProducts = <DanModel>[].obs;

  //top rating merchant profiles
  Future<List<UserModel>> getTrendingProfiles() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('type', isEqualTo: 'MERCHANT')
          .orderBy('rating', descending: true)
          .limit(25)
          .get();
      final List<UserModel> topRatingProfiles = querySnapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data());
      }).toList();
      return topRatingProfiles;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //best selling products
  getBestSelling() async {
    try {
      final querySnapshot = await _firestore
          .collection('posts')
          .where('isredan', isEqualTo: false)
          .where('user.type', isEqualTo: 'MERCHANT')
          .orderBy('rating', descending: true)
          .get();
      final List<DanModel> bestSellingProducts = querySnapshot.docs.map((doc) {
        return DanModel.fromJson(doc.data());
      }).toList();
      return bestSellingProducts;
    } catch (e) {
      print("Erorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      print(e.toString());
      return [];
    }
  }
}
