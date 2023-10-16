import 'package:disan/Contoller/auth_controller.dart';
import 'package:disan/Core/style/button_style.dart';
import 'package:disan/Core/style/colors.dart';
import 'package:disan/Core/style/input_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final controller = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Obx(() {
          return Container(
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
                    height: Get.height * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (val) {
                            controller.name.value = val;
                          },
                          validator: (val) =>
                              (val!.isEmpty) ? "Enter your name".tr : null,
                          decoration: InputDecoration(
                            labelText: "Name".tr,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            enabledBorder: enabledBorder,
                            errorBorder: errorBorder,
                            focusedBorder: focusedBorder,
                            focusedErrorBorder: fucsedErrorBorder,
                            prefixIcon: const Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
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
                          height: 15,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (val) {
                            controller.password.value = val;
                          },
                          validator: (val) => (val!.isEmpty)
                              ? "Please enter a valid password".tr
                              : null,
                          decoration: InputDecoration(
                              labelText: "Password".tr,
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              enabledBorder: enabledBorder,
                              errorBorder: errorBorder,
                              focusedBorder: focusedBorder,
                              focusedErrorBorder: fucsedErrorBorder,
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: InkWell(
                                onTap: () =>
                                    controller.changeObscureTextStatus(),
                                child: const Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: primaryColor,
                                ),
                              )),
                          obscureText: controller.textObsecured.value,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (val) {
                            controller.password.value = val;
                          },
                          validator: (val) => (val!.isEmpty)
                              ? "Please enter a valid password".tr
                              : null,
                          decoration: InputDecoration(
                            labelText: "Confirm password".tr,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            enabledBorder: enabledBorder,
                            errorBorder: errorBorder,
                            focusedBorder: focusedBorder,
                            focusedErrorBorder: fucsedErrorBorder,
                            prefixIcon: const Icon(Icons.lock),
                          ),
                          obscureText: controller.textObsecured.value,
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: primaryButtonStyle,
                          child: Text("Register".tr),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("I hav an account ? ".tr),
                            InkWell(
                              onTap: () => Get.back(),
                              child: Text(
                                "Login".tr,
                                style: const TextStyle(color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: Get.height * 0.08,
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
          );
        }));
  }
}
