import 'package:disan/Controller/chat_controller.dart';
import 'package:disan/Controller/local_storage.dart';
import 'package:disan/Core/style/button_style.dart';
import 'package:disan/Model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class ChatRegister extends StatefulWidget {
  const ChatRegister({super.key});

  @override
  State<ChatRegister> createState() => _ChatRegisterState();
}

class _ChatRegisterState extends State<ChatRegister> {
  @override
  void initState() {
    controller.isUserRegisterd();
    super.initState();
  }

  final _prefs = Get.find<SharedPrefsController>();

  final controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return _prefs.userAuthenticated()
        ? Obx(
            () {
              return DefaultTabController(
                length: 2,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    title: Text("Chat".tr),
                    centerTitle: true,
                    backgroundColor: Colors.white,
                    titleTextStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    bottom: controller.userRegisterd.value == true
                        ? TabBar(
                            labelColor: Colors.green,
                            indicatorColor: Colors.green,
                            tabs: [
                              Tab(
                                text: 'Users'.tr,
                                //  icon: const Icon(Icons.home),
                              ),
                              Tab(
                                text: 'Merchants'.tr,
                                // icon: const Icon(Icons.shopping_bag_sharp),
                              ),
                            ],
                          )
                        : null,
                  ),
                  body: Container(
                    padding: const EdgeInsets.all(0),
                    width: Get.width,
                    height: Get.height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/bckground.jpg"),
                        fit: BoxFit.none,
                      ),
                    ),
                    child: Obx(
                      () {
                        return controller.userRegisterd.value == true
                            ? RegisteredUsersList(controller: controller)
                            : RegisterPage(controller: controller);
                      },
                    ),
                  ),
                ),
              );
            },
          )
        : Center(
            child: Text("You have to sign in to be able to use this page".tr),
          );
  }
}

class RegisteredUsersList extends StatelessWidget {
  const RegisteredUsersList({
    super.key,
    required this.controller,
  });

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        ChatTabView(
          controller: controller,
          type: "USER",
        ),
        ChatTabView(
          controller: controller,
          type: "MERCHANT",
        ),
      ],
    );
  }
}

class ChatTabView extends StatelessWidget {
  const ChatTabView({super.key, required this.controller, required this.type});
  final ChatController controller;
  final String type;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FutureBuilder(
        future: controller.getOtherRegisteredUsers(type),
        builder: (context, snapshot) {
          List<UserModel> users = snapshot.data ?? [];
          if (users.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return InkWell(
                onTap: () => controller.makeContactAction(user),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ListTile(
                      title: Text(user.name ?? "unknown"),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          user.profile.toString(),
                        ),
                      ),
                      trailing: controller.amIAllowedToContactHim(user)
                          ? const Icon(
                              Ionicons.logo_whatsapp,
                              color: Colors.green,
                              size: 35,
                            )
                          : TextButton(
                              onPressed: () =>
                                  controller.requestConnection(user),
                              child: Text("Request".tr),
                            ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({
    super.key,
    required this.controller,
  });

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            height: Get.height * 0.40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  leading: const Icon(
                    Ionicons.logo_whatsapp,
                    size: 50,
                    color: Colors.green,
                  ),
                  title: Text("Conversations are via whatsapp".tr),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Checkbox(
                      value: controller.hidePhone.value,
                      onChanged: (value) => controller.flipHideCheckBox(),
                    ),
                    Text(
                      "Hide phone number".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: TextFormField(
                    onChanged: (value) {
                      controller.phone.value = value;
                    },
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    textInputAction: TextInputAction.send,
                    onFieldSubmitted: (value) => controller.registerChat(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Phone number".tr,
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: Colors.black,
                        size: 40,
                      ),
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                controller.phone.value.length >= 11
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: ElevatedButton(
                          onPressed: () => controller.registerChat(),
                          style: primaryButtonStyle,
                          child: Text("Register".tr),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
