import 'package:auth_buttons/auth_buttons.dart';
import 'package:disan/Controller/auth_controller.dart';
import 'package:disan/Core/style/button_style.dart';
import 'package:disan/Core/style/colors.dart';
import 'package:disan/Core/style/input_style.dart';
import 'package:disan/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final controller = Get.put(AuthController(), permanent: true);
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
              image: AssetImage("assets/bckground.jpg"),
              fit: BoxFit.none,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  width: Get.width * 0.86,
                  height: Get.height * 0.75,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Form(
                    key: controller.loginFormKey,
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
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (val) {
                            controller.password.value = val;
                          },
                          validator: (val) => (val!.isEmpty || val.length < 6)
                              ? "Password lengh should be at least 6".tr
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
                          height: 22,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: controller.rememberMe.value,
                              onChanged: (value) => {
                                controller.rememberMe.value = value!,
                              },
                            ),
                            Text("Remember me".tr),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () => Get.toNamed(Routes.reset),
                              child: Text(
                                "Forgot password".tr,
                                style: const TextStyle(color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final form = controller.loginFormKey.currentState;
                            if (form!.validate()) {
                              form.save();
                              controller.signInWithEmailAndPassword();
                            }
                          },
                          style: primaryButtonStyle,
                          child: Text("Login".tr),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't you have an account ? ".tr,
                              style: TextStyle(fontSize: 18),
                            ),
                            InkWell(
                              onTap: () => Get.toNamed(Routes.signup),
                              child: Text(
                                "Register".tr,
                                style: const TextStyle(color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        SizedBox(
                          width: Get.width,
                          child: Row(
                            children: [
                              const Expanded(
                                  child: Divider(
                                thickness: 1.4,
                              )),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Or'.tr,
                                ),
                              ),
                              const Expanded(
                                  child: Divider(
                                thickness: 1.4,
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GoogleAuthButton(
                              isLoading: controller.isGoogleLoading.value,
                              onPressed: () => controller.loginWithGoogle(),
                              style: const AuthButtonStyle(
                                buttonType: AuthButtonType.icon,
                                iconType: AuthIconType.secondary,
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            FacebookAuthButton(
                              isLoading: controller.isFacebookLoading.value,
                              onPressed: () => controller.loginWithFacebook(),
                              style: const AuthButtonStyle(
                                buttonType: AuthButtonType.icon,
                                iconType: AuthIconType.secondary,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
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
            ],
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.offAndToNamed(Routes.navbar),
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(" Skip".tr),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ],
        ),
        backgroundColor: Colors.red.shade300,
      ),
    );
  }
}
