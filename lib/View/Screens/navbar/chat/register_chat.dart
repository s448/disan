import 'package:disan/Controller/chat_controller.dart';
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

  final controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Chat register".tr),
        centerTitle: true,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        width: Get.width,
        height: Get.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bckground.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Obx(() {
          return controller.userRegisterd.value == true
              ? RegisteredUsersList(controller: controller)
              : RegisterPage(controller: controller);
        }),
      ),
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
    return FutureBuilder(
      future: controller.getOtherRegisteredUsers(),
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
              child: Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ListTile(
                  title: Text(user.name ?? "unknown"),
                  trailing: controller.amIAllowedToContactHim(user)
                      ? const Icon(
                          Ionicons.logo_whatsapp,
                          color: Colors.green,
                          size: 35,
                        )
                      : TextButton(
                          onPressed: () => controller.requestConnection(user),
                          child: Text("Request".tr),
                        ),
                ),
              ),
            );
          },
        );
      },
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
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          TextFormField(
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
                borderSide: const BorderSide(color: Colors.white),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              fillColor: Colors.white,
              filled: true,
              hintText: "Phone number ex (+1) ...",
              prefixIcon: const Icon(
                Ionicons.logo_whatsapp,
                color: Colors.green,
                size: 40,
              ),
              hintStyle: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 14),
          controller.phone.value.length >= 11
              ? ElevatedButton(
                  onPressed: () => controller.registerChat(),
                  style: primaryButtonStyle,
                  child: Text("Register".tr),
                )
              : const SizedBox(),
        ],
      );
    });
  }
}
