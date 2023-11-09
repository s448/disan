import 'package:disan/Controller/local_storage.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Service/fcm_services.dart';
import 'package:disan/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Get.putAsync(() => SharedPreferences.getInstance(), permanent: true);
  // Get.put(UserController(), permanent: true);
  // await FcmServices().initNotification();
  return runApp(DisanApp());
}

class DisanApp extends StatelessWidget {
  final _sharedPrefController =
      Get.put(SharedPrefsController(), permanent: true);
  DisanApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      textDirection: TextDirection.ltr,
      debugShowCheckedModeBanner: false,
      initialRoute: _sharedPrefController.userAuthenticated()
          ? Routes.navbar
          : Routes.introScreen,
      getPages: getPages,
    );
  }
}
