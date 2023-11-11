// ignore_for_file: invalid_use_of_protected_member

import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class BlockList extends StatelessWidget {
  BlockList({super.key});
  final userController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Block list".tr),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(
        () {
          return Container(
            width: Get.width,
            height: Get.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bckground.jpg"),
                fit: BoxFit.none,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: userController.blockedUsers.value.length,
                itemBuilder: (context, index) {
                  UserModel user = userController.blockedUsers.value[index];
                  return Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ListTile(
                      leading: user.profile!.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.blue,
                            )
                          : Image.network(user.profile ?? ""),
                      title: Text(user.name ?? "unknown"),
                      trailing: IconButton(
                        icon: const Icon(
                          Ionicons.remove_circle,
                          color: Colors.green,
                        ),
                        onPressed: () =>
                            userController.unblockUser(user.id ?? ""),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
