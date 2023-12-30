import 'package:disan/Controller/ads_controller.dart';
import 'package:disan/Controller/local_storage.dart';
import 'package:disan/Controller/locale_controller.dart';
import 'package:disan/Core/ultis/translation_sheet.dart';
import 'package:disan/Service/fcm_services.dart';
import 'package:disan/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  await Get.putAsync(() => SharedPreferences.getInstance(), permanent: true);
  Get.put(AdsController(), permanent: true);
  // Get.put(UserController(), permanent: true);
  await FcmServices().initNotification();
  return runApp(DisanApp());
}

class DisanApp extends StatelessWidget {
  final _sharedPrefController =
      Get.put(SharedPrefsController(), permanent: true);

  DisanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeController = Get.put(LocaleController(), permanent: true);
    // print(_sharedPrefController.prefs.getString('lang'));
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent, // Navigation bar color
      statusBarColor: Colors.transparent, // Status bar color
    ));
    return GetMaterialApp(
      title: 'Disan',
      translations: TranslationSheet(),
      locale: localeController.initLocale,
      fallbackLocale: const Locale('en', 'US'),
      textDirection: TextDirection.ltr,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.blue),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
          indicatorColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            textStyle: MaterialStateProperty.all(
              TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          backgroundColor: Colors.blue,
          actionsIconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => Colors.blue)),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            iconColor: MaterialStateProperty.all(
              Colors.blue,
            ),
          ),
        ),
      ),
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
