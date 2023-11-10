import 'package:disan/Controller/local_storage.dart';
import 'package:disan/Controller/locale_controller.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Core/ultis/translation_sheet.dart';
import 'package:disan/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  await Get.putAsync(() => SharedPreferences.getInstance(), permanent: true);
  Get.put(UserController(), permanent: true);
  // await FcmServices().initNotification();
  return runApp(DisanApp());
}

class DisanApp extends StatelessWidget {
  final _sharedPrefController =
      Get.put(SharedPrefsController(), permanent: true);

  DisanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeController = Get.put(LocaleController(), permanent: true);
    print(_sharedPrefController.prefs.getString('lang'));

    return GetMaterialApp(
      translations: TranslationSheet(),
      locale: localeController.initLocale,
      fallbackLocale: const Locale('en', 'US'),
      textDirection: TextDirection.ltr,
      debugShowCheckedModeBanner: false,
      initialRoute: _sharedPrefController.userAuthenticated()
          ? Routes.navbar
          : Routes.introScreen,
      getPages: getPages,
      builder: (context, child) {
        return Directionality(
          textDirection: localeController.isArabic()
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: child!,
        );
      },
    );
  }
}
