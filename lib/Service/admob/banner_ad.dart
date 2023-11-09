import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdService {
  static const String bannerAdUnitId = "ca-app-pub-3940256099942544/6300978111";

  BannerAd bannerAd = BannerAd(
    adUnitId: bannerAdUnitId,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (Ad ad) => log("Ad Banner loaded ---------------------"),
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        log("Ad Banner failed to load ---------------------");
      },
    ),
  );
}
