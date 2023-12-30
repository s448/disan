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
            color: Colors.blue,
          ),
        ),
      ),
      body: ProfilePageTemp(userId: userId),
    );
  }
}
