import 'package:disan/Controller/locale_controller.dart';
import 'package:disan/View/Widgets/settings_item_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseLangPage extends StatelessWidget {
  ChooseLangPage({super.key});
  final controller = Get.find<LocaleController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Choose langauge".tr),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SettingsItemButton(
              action: () => controller.changeAppLanguage('en', 'US'),
              // leading: const Icon(
              //   Icons.block,
              //   color: Colors.grey,
              //   size: 35,
              // ),
              trailing: const Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.grey,
                size: 35,
              ),
              title: "English".tr,
            ),
            const SizedBox(height: 25),
            SettingsItemButton(
              action: () => controller.changeAppLanguage('ar', 'EG'),
              trailing: const Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.grey,
                size: 35,
              ),
              title: "Arabic".tr,
            ),
          ],
        ),
      ),
    );
  }
}
