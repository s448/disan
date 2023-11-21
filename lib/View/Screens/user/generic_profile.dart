import 'dart:developer';

import 'package:disan/View/Widgets/profileWidgets/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void dispose() {
    super.dispose();
    log(Get.arguments['uid']);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log(Get.arguments['uid']);
  }

  @override
  Widget build(BuildContext context) {
    final userId = Get.arguments['uid'];
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
        // actions: [
        //   InkWell(
        //     onTap: () => Get.toNamed(Routes.settings),
        //     child: const Icon(
        //       Icons.settings,
        //       color: Colors.white,
        //       size: 35,
        //     ),
        //   ),
        //   const SizedBox(width: 12),
        // ],
      ),
      body: ProfilePageTemp(userId: userId),
    );
  }
}
