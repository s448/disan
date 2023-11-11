import 'package:disan/Service/admob/banner_ad.dart';
import 'package:disan/Service/admob/rewarded_ad.dart';
import 'package:get/get.dart';

class AdsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    bannerAdService.bannerAd.load();
    rewardedAdService.createRewardedAd();
  }

  @override
  void dispose() {
    super.dispose();
    bannerAdService.bannerAd.dispose();
    rewardedAdService.rewardedAd?.dispose();
  }

  final bannerAdService = BannerAdService();
  final rewardedAdService = RewaredeAdService();

  loadBannerAd() {
    bannerAdService.bannerAd.listener.onAdLoaded;
  }

  // isBannerAdLoaded() => bannerAdService.adLoaded;

  showRewardedAd() {
    rewardedAdService.showRewardedAd();
  }
}
