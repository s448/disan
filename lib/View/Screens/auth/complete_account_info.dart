import 'package:disan/Contoller/auth_controller.dart';
import 'package:disan/Contoller/user_controller.dart';
import 'package:disan/Core/style/input_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompleteAccountInfo extends StatelessWidget {
  CompleteAccountInfo({super.key});
  final controller = Get.put(UserController());
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    bool isUser = authController.accType.value == "USER";
    return Scaffold(
      appBar: AppBar(
        title: Text(isUser ? "Edit user info".tr : "Edit your Shop"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: controller.editInfoFormKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 22,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) {
                    controller.name.value = val;
                  },
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter your name".tr : null,
                  decoration: InputDecoration(
                    labelText: "Your name".tr,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    enabledBorder: enabledBorder,
                    errorBorder: errorBorder,
                    focusedBorder: focusedBorder,
                    focusedErrorBorder: fucsedErrorBorder,
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) {
                    controller.name.value = val;
                  },
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter your bio".tr : null,
                  decoration: InputDecoration(
                    labelText: "Your bio".tr,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    enabledBorder: enabledBorder,
                    errorBorder: errorBorder,
                    focusedBorder: focusedBorder,
                    focusedErrorBorder: fucsedErrorBorder,
                    prefixIcon: const Icon(Icons.text_snippet_rounded),
                  ),
                  minLines: 4,
                  maxLines: 5,
                ),
                const SizedBox(
                  height: 22,
                ),
                !isUser
                    ? InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: ListTile(
                            iconColor: Colors.blue,
                            leading: const Icon(Icons.location_on_outlined),
                            title: Text("Location".tr),
                            subtitle:
                                Text("Select your location on google maps".tr),
                          ),
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 18,
                ),
                InkWell(
                  onTap: () => controller.selectProfilePic(),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: ListTile(
                      iconColor: Colors.blue,
                      trailing: const Icon(
                        CupertinoIcons.profile_circled,
                        size: 35,
                      ),
                      title: Text("Select your profile picture".tr),
                      // subtitle: Text("Select your location on google maps".tr),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                InkWell(
                  onTap: () => controller.selectBackgroundPic(),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: ListTile(
                      iconColor: Colors.blue,
                      trailing: const Icon(
                        CupertinoIcons.photo,
                        size: 35,
                      ),
                      title: Text("Select your background image".tr),
                      // subtitle: Text("Select your location on google maps".tr),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
