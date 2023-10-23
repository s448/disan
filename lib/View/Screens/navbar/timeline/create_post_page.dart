import 'package:disan/Controller/timeline_tap_controller.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Core/style/button_style.dart';
import 'package:disan/View/Widgets/img_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePostPage extends StatelessWidget {
  CreatePostPage({super.key});
  final userController = Get.find<UserController>();
  final controller = Get.put(TimelineTapController());
  @override
  Widget build(BuildContext context) {
    final currentUserModel = userController.curentUserModel;

    return Scaffold(
      appBar: AppBar(
        title: Text("Create post".tr),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 32.0,
                  backgroundColor: Colors.blue,
                  backgroundImage: NetworkImage(
                    currentUserModel.profile.toString(),
                  ),
                ),
                title: Text(currentUserModel.name.toString()),
              ),
              const SizedBox(
                height: 12.0,
              ),
              TextFormField(
                onChanged: (value) {
                  controller.description.value = value;
                },
                maxLines: 6,
                minLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: const Color.fromARGB(255, 194, 192, 192),
                  filled: true,
                  // border: InputBorder.none,
                  hintText: "What's on your mind ?".tr,
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              InkWell(
                onTap: () => controller.pickMultipleImages(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.image_outlined,
                        color: Colors.red,
                        size: 32,
                      ),
                      Text("Add photo".tr),
                    ],
                  ),
                ),
              ),
              controller.images!.isEmpty
                  ? const SizedBox()
                  : SizedBox(
                      height: Get.height * 0.18,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: controller.images!.length,
                        itemBuilder: (context, index) {
                          return ImageTile(xFile: controller.images![index]);
                        },
                      ),
                    ),
              const SizedBox(
                height: 12.0,
              ),
              ElevatedButton(
                onPressed: () => controller.createPost(),
                style: primaryButtonStyle,
                child: controller.postButtonUploading.value
                    ? const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        "Post".tr,
                      ),
              )
            ],
          ),
        );
      }),
    );
  }
}
