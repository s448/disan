import 'package:disan/Contoller/auth_controller.dart';
import 'package:disan/Core/style/button_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SelectAccountTypePage extends StatelessWidget {
  SelectAccountTypePage({super.key});
  final controller = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            ToggleSwitch(
              minWidth: 90.0,
              minHeight: 70.0,
              initialLabelIndex: 0,
              cornerRadius: 20.0,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              totalSwitches: 2,
              icons: const [
                CupertinoIcons.person_crop_rectangle,
                Icons.add_business_outlined,
              ],
              iconSize: 30.0,
              activeBgColors: const [
                [Colors.black45, Colors.black26],
                [Colors.yellow, Colors.orange]
              ],
              animate:
                  true, // with just animate set to true, default curve = Curves.easeIn
              curve: Curves
                  .bounceInOut, // animate must be set to true when using custom curve
              onToggle: (index) {
                controller.setAccountType(index);
                print('switched to: $index');
              },
            ),
            ElevatedButton(
              onPressed: () => controller.updateAccountType(),
              style: primaryButtonStyle,
              child: Text("Continue".tr),
            )
          ],
        ),
      ),
    );
  }
}
