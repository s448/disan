import 'package:disan/Controller/auth_controller.dart';
import 'package:disan/View/Widgets/settings_item_button.dart';
import 'package:disan/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  final authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Settings".tr),
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
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.lang),
            icon: const Icon(
              Icons.translate_rounded,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        width: Get.width,
        height: Get.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bckground.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SettingsItemButton(
                action: () => Get.toNamed(Routes.block),
                leading: const Icon(
                  Icons.block,
                  color: Colors.grey,
                  size: 35,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.grey,
                  size: 35,
                ),
                title: "Block List".tr,
              ),
              const SizedBox(height: 12),
              SettingsItemButton(
                action: () async {
                  await authController.logout();
                  Get.offAllNamed(Routes.login);
                },
                leading: const Icon(
                  Icons.logout,
                  color: Colors.grey,
                  size: 35,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.grey,
                  size: 35,
                ),
                title: "Sign out".tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
