import 'package:disan/Controller/shop_tap_controller.dart';
import 'package:disan/Model/user_model.dart';
import 'package:disan/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({super.key});
  final controller = Get.find<ShopTapController>();
  final category = Get.arguments['cat'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text(category.toString()),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: controller.getCategoryMembers(category),
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
                  onTap: () =>
                      Get.toNamed(Routes.profile, arguments: {"uid": user.id}),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ListTile(
                      title: Text(user.name ?? "unknown"),
                      subtitle: Text(category),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          user.profile.toString(),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
