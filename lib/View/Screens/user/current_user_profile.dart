import 'package:disan/Controller/local_storage.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/View/Widgets/profileWidgets/profile_view.dart';
import 'package:disan/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurrentUserProfile extends StatelessWidget {
  CurrentUserProfile({super.key});
  final _userController = Get.put(UserController());
  final _prefs = Get.find<SharedPrefsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Profile".tr),
          centerTitle: true,
          // leading: IconButton(
          //   onPressed: () => Get.back(),
          //   icon: const Icon(
          //     Icons.arrow_back_ios,
          //     color: Colors.white,
          //   ),
          // ),
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
        body: _prefs.userAuthenticated()
            ? ProfilePageTemp(
                userId: _userController.curentUserModel.id.toString())
            : Center(
                child:
                    Text("You have to sign in to be able to use this page".tr),
              ));
  }
}
