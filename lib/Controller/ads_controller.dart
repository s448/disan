// import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'dart:developer';

// class AdsController extends GetxController {
//   static const String bannerAdUnitId = "ca-app-pub-3940256099942544/6300978111";
//   static const String rewardedAdUnitId =
//       'ca-app-pub-3940256099942544/5224354917';

//   // RxBool timelineBannerLoaded = false.obs;
//   // RxBool shopBannerLoaded = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     timelineAdBanner.load();
//     shopAdBanner.load();
//     createRewardedAd();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     timelineAdBanner.dispose();
//     shopAdBanner.dispose();
//     rewardedAd?.dispose();
//   }

//   loadBannerAd() {
//     timelineAdBanner.listener.onAdLoaded;
//     shopAdBanner.listener.onAdLoaded;
//   }

//   BannerAd timelineAdBanner = BannerAd(
//     adUnitId: bannerAdUnitId,
//     size: AdSize.banner,
//     request: const AdRequest(),
//     listener: BannerAdListener(
//       onAdLoaded: (Ad ad) => log("Ad Banner loaded ---------------------"),
//       onAdFailedToLoad: (Ad ad, LoadAdError error) {
//         ad.dispose();
//         log("Ad Banner failed to load ---------------------");
//       },
//     ),
//   );

//   BannerAd shopAdBanner = BannerAd(
//     adUnitId: bannerAdUnitId,
//     size: AdSize.banner,
//     request: const AdRequest(),
//     listener: BannerAdListener(
//       onAdLoaded: (Ad ad) => log("Ad Banner loaded ---------------------"),
//       onAdFailedToLoad: (Ad ad, LoadAdError error) {
//         ad.dispose();
//         log("Ad Banner failed to load ---------------------");
//       },
//     ),
//   );

//   RewardedAd? rewardedAd;
//   int _numRewardedLoadAttempts = 0;

//   void createRewardedAd() {
//     RewardedAd.load(
//       adUnitId: rewardedAdUnitId,
//       request: const AdRequest(),
//       rewardedAdLoadCallback: RewardedAdLoadCallback(
//         onAdLoaded: (RewardedAd ad) {
//           print('$ad loaded.');
//           rewardedAd = ad;
//           _numRewardedLoadAttempts = 0;
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           print('RewardedAd failed to load: $error');
//           rewardedAd = null;
//           _numRewardedLoadAttempts += 1;
//           if (_numRewardedLoadAttempts < 3) {
//             createRewardedAd();
//           }
//         },
//       ),
//     );
//   }

//   void showRewardedAd() {
//     if (rewardedAd == null) {
//       print('Warning: attempt to show rewarded before loaded.');
//       return;
//     }
//     rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (RewardedAd ad) =>
//           print('ad onAdShowedFullScreenContent.'),
//       onAdDismissedFullScreenContent: (RewardedAd ad) {
//         print('$ad onAdDismissedFullScreenContent.');
//         ad.dispose();
//         createRewardedAd();
//       },
//       onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
//         print('$ad onAdFailedToShowFullScreenContent: $error');
//         ad.dispose();
//         createRewardedAd();
//       },
//     );

//     rewardedAd!.setImmersiveMode(true);
//     rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
//       print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
//     });
//     rewardedAd = null;
//   }
// }
