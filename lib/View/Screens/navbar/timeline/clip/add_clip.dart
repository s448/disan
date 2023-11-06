import 'dart:io';
import 'package:disan/Controller/clip_controller.dart';
import 'package:disan/View/Screens/navbar/timeline/story/add_story.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class AddClipPage extends StatelessWidget {
  AddClipPage({super.key});
  final controller = Get.find<ClipController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Create clip'),
        // centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(() {
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Center(
                      child: Obx(() {
                        final file = controller.file.value;
                        return VideoPlayerWidget(
                          videoPlayerController: VideoPlayerController.file(
                            File(file!.path),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) {
                            controller.caption.value = value;
                          },
                          textInputAction: TextInputAction.send,
                          onFieldSubmitted: (value) => controller.uploadClip(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            fillColor: Colors.black,
                            filled: true,
                            hintText: "Add Caption ..",
                            hintStyle: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => controller.uploadClip(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.upload_outlined,
                                color: Colors.green,
                                size: 35,
                              ),
                              Text(
                                "Upload".tr,
                                style: const TextStyle(color: Colors.green),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            controller.storyUploading.value
                ? Positioned(
                    top: Get.height * 0.4,
                    right: Get.width * 0.45,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox(),
          ],
        );
      }),
    );
  }
}
