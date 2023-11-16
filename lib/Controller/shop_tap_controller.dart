import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:disan/Model/user_model.dart';
// import 'package:disan/Service/admob/banner_ad.dart';
// import 'package:disan/Service/admob/rewarded_ad.dart';
import 'package:get/get.dart';

class ShopTapController extends GetxController {
  @override
  void dispose() {
    super.dispose();
    // bannerAdService.bannerAd.dispose();
    // rewardedAdService.rewardedAd?.dispose();
  }

  // final bannerAdService = BannerAdService();
  // final rewardedAdService = RewaredeAdService();

  @override
  void onInit() async {
    trendingProfiles.value = await getTrendingProfiles();
    bestSellingProducts.value = await getBestSelling();
    // bannerAdService.bannerAd.load();
    // rewardedAdService.createRewardedAd();
    super.onInit();
  }

  // showRewardedAd() {
  //   rewardedAdService.showRewardedAd();
  // }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<UserModel> trendingProfiles = <UserModel>[].obs;
  RxList<UserModel> bestSellingProducts = <UserModel>[].obs;

  _getListOfBestSelling() async {
    var querySnapshot = await _firestore
        .collection('posts')
        .where('addtocartcount', isGreaterThanOrEqualTo: 15)
        .get();

    final List<DanModel> bestSellingProducts = querySnapshot.docs.map((doc) {
      return DanModel.fromJson(doc.data());
    }).toList();
    return bestSellingProducts;
  }

  //top rating merchant profiles
  Future<List<UserModel>> getTrendingProfiles() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('ratescount', isGreaterThanOrEqualTo: 30)
          .orderBy('rating', descending: true)
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
  Future<List<UserModel>> getBestSelling() async {
    try {
      List<DanModel> bestSellingProducts = await _getListOfBestSelling();
      List<String> ids = [];
      for (var uid in bestSellingProducts) {
        ids.add(uid.user!.id ?? "");
      }

      var res =
          await _firestore.collection('users').where('id', whereIn: ids).get();

      final List<UserModel> bestSellingOwners = res.docs.map((doc) {
        return UserModel.fromJson(doc.data());
      }).toList();
      return bestSellingOwners;
    } catch (e) {
      return [];
    }
  }

  Future<List<UserModel>> getCategoryMembers(String cat) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('categories', arrayContains: cat)
          .orderBy('rating', descending: true)
          .get();
      final List<UserModel> catUsers = querySnapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data());
      }).toList();
      return catUsers;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
