import 'package:disan/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Get.putAsync(() => SharedPreferences.getInstance(), permanent: true);
  return runApp(const DisanApp());
}

class DisanApp extends StatelessWidget {
  const DisanApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      textDirection: TextDirection.ltr,
      debugShowCheckedModeBanner: false,
      // theme: StyleManager.themeManager,
      initialRoute: Routes.login,
      getPages: getPages,
    );
  }
}
