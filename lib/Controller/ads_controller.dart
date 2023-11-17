import 'package:disan/Service/admob/banner_ad.dart';
import 'package:disan/Service/admob/rewarded_ad.dart';
import 'package:get/get.dart';

class AdsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    bannerAdService.homePageAdBanner.load();
    bannerAdService.timelinePageAdBanner.load();
    rewardedAdService.createRewardedAd();
  }

  @override
  void dispose() {
    super.dispose();
    bannerAdService.homePageAdBanner.dispose();
    bannerAdService.timelinePageAdBanner.dispose();
    rewardedAdService.rewardedAd?.dispose();
  }

  final bannerAdService = BannerAdService();
  final rewardedAdService = RewaredeAdService();

  loadBannerAd() {
    bannerAdService.homePageAdBanner.listener.onAdLoaded;
    bannerAdService.timelinePageAdBanner.listener.onAdLoaded;
  }

  // isBannerAdLoaded() => bannerAdService.adLoaded;

  showRewardedAd() {
    rewardedAdService.showRewardedAd();
  }
}
