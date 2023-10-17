import 'package:disan/Contoller/auth_controller.dart';
import 'package:disan/Core/style/button_style.dart';
import 'package:disan/Core/style/input_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({super.key});
  final controller = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bckgound.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                width: Get.width * 0.86,
                height: Get.height * 0.3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Form(
                  key: controller.resetPasswordFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (val) {
                          controller.email.value = val;
                        },
                        validator: (val) => (val!.isEmpty || !val.isEmail)
                            ? "Incorrect email".tr
                            : null,
                        decoration: InputDecoration(
                          labelText: "Email address".tr,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          enabledBorder: enabledBorder,
                          errorBorder: errorBorder,
                          focusedBorder: focusedBorder,
                          focusedErrorBorder: fucsedErrorBorder,
                          prefixIcon: const Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final form =
                              controller.resetPasswordFormKey.currentState;
                          if (form!.validate()) {
                            form.save();
                            controller.sendResetPasswordLink();
                          }
                        },
                        style: primaryButtonStyle,
                        child: Text("Send code".tr),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: Get.height * 0.28,
              left: 0,
              right: 0,
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
              ),
            ),
            Positioned(
              top: 40,
              left: 26,
              child: InkWell(
                onTap: () => Get.back(),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white38,
                  child: Icon(Icons.arrow_back_ios_new),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
