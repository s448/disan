import 'package:disan/Controller/auth_controller.dart';
import 'package:disan/Core/style/button_style.dart';
import 'package:disan/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SelectAccountTypePage extends StatelessWidget {
  SelectAccountTypePage({super.key});
  final controller = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select your account type".tr),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ToggleSwitch(
              minWidth: Get.width,
              minHeight: 70.0,
              cornerRadius: 20.0,
              labels: ["User".tr, "Merchant".tr],
              centerText: true,
              initialLabelIndex: 0,
              multiLineText: true,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              totalSwitches: 2,
              icons: const [
                CupertinoIcons.person_crop_rectangle,
                Icons.add_business_outlined,
              ],
              iconSize: 30.0,
              animate: true,
              curve: Curves.linear,
              onToggle: (index) {
                controller.setAccountType(index);
              },
            ),
            const SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  controller.updateCurrentUserInfo();
                  Get.toNamed(Routes.completeUserInfo);
                },
                style: primaryButtonStyle,
                child: Text("Continue".tr),
              ),
            )
          ],
        ),
      ),
    );
  }
}
