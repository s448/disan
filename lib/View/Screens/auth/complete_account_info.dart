import 'package:disan/Controller/auth_controller.dart';
import 'package:disan/Controller/location_controller.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Core/style/input_style.dart';
import 'package:disan/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class CompleteAccountInfo extends StatelessWidget {
  CompleteAccountInfo({super.key});
  final controller = Get.put(UserController());
  final authController = Get.find<AuthController>();
  final MapController _mapController =
      Get.put(MapController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    bool isUser = authController.accType.value == "USER";
    return Scaffold(
      appBar: AppBar(
        title: Text(isUser ? "Edit user info".tr : "Edit your Shop"),
      ),
      body: Obx(
         () {
          return Padding(
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
                        controller.name?.value = val;
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
                        prefixIcon: const Icon(Icons.person,color: Colors.blue,),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        controller.whatsappNumber.value = val;
                      },
                      validator: (val) =>
                      (val!.isEmpty) ? "Enter your Whatsapp number".tr : null,
                      decoration: InputDecoration(
                        labelText: "Your Whatsapp number".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        enabledBorder: enabledBorder,
                        errorBorder: errorBorder,
                        focusedBorder: focusedBorder,
                        focusedErrorBorder: fucsedErrorBorder,
                        prefixIcon: const Icon(Ionicons.logo_whatsapp,color: Colors.green,),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (val) {
                        controller.bio?.value = val;
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
                        prefixIcon: const Icon(Icons.text_snippet_rounded,color: Colors.blue,),
                      ),
                      minLines: 4,
                      maxLines: 5,
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    !isUser
                        ? InkWell(
                            onTap: () => Get.toNamed(Routes.maps),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: ListTile(
                                iconColor: Colors.blue,
                                leading: const Icon(Icons.location_on_outlined),
                                title: Text(_mapController.position == null
                                    ? "Location".tr
                                    : "Position selected".tr),
                                subtitle: Text(
                                  _mapController.position == null
                                      ? "Select your location on google maps".tr
                                      : "Tap to change it".tr,
                                ),
                                // trailing: Text((_mapController.position ?? 0.0).toString()),
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
                          trailing: controller.profilePicUrl.value.isEmpty
                              ? const Icon(
                                  CupertinoIcons.profile_circled,
                                  size: 35,
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Image.network(
                                      controller.profilePicUrl.value.toString()),
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
                          trailing: controller.backgroundPicUrl.value.isEmpty
                              ? const Icon(
                                  CupertinoIcons.photo,
                                  size: 35,
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Image.network(
                                      controller.backgroundPicUrl.value.toString()),
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
          );
        }
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            controller.locationLat?.value = _mapController.position?.latitude ?? 0.0;
            controller.locationLng?.value = _mapController.position?.longitude ?? 0.0;
            print(controller.name.value);
            print(controller.bio.value);
            print(controller.whatsappNumber.value);
            print(controller.locationLat);
            print(controller.locationLng);
            print(controller.profilePicUrl);
            print(controller.backgroundPicUrl);
          },
          label: Text("Save your info".tr),
          icon: const Icon(
            Icons.save,
          ),
        ),
      ),
    );
  }
}
