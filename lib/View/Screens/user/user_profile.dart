import 'package:disan/View/Widgets/profileWidgets/profile_view.dart';
import 'package:disan/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final userId = Get.arguments['uid'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile".tr),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        actions: [
          InkWell(
            onTap: () => Get.toNamed(Routes.settings),
            child: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 35,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ProfilePageTemp(userId: userId),
    );
  }
}
