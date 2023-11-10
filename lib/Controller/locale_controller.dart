import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends GetxController {
  @override
  void onInit() {
    getAppLocale();
    super.onInit();
  }

  final prefs = Get.find<SharedPreferences>();
  Locale? initLocale;
  getAppLocale() {
    initLocale = prefs.getString("lang") == "ar"
        ? const Locale('ar', 'EG')
        : const Locale('en', 'US');
  }

  changeAppLanguage(String lang, String country) {
    var locale = Locale(lang, country);
    prefs.setString('lang', lang);
    Get.updateLocale(locale);
  }

  bool isArabic() => Get.locale == const Locale('ar', 'EG');
}
