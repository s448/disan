import 'dart:ui';

import 'package:get/get.dart';

class LocaleController extends GetxController {
  changeAppLanguage(String lang, String country) {
    var locale = Locale(lang, country);

    Get.updateLocale(locale);
    print(Get.locale);
  }
}
