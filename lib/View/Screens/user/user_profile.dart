import 'package:disan/View/Widgets/profile_view.dart';
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
      ),
      body: ProfilePageTemp(userId: userId),
    );
  }
}
