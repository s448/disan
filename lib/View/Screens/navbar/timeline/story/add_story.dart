import 'dart:io';

import 'package:disan/Controller/story_controller.dart';
import 'package:disan/Core/enum/media_types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:photo_view/photo_view.dart';

class MediaViewerPage extends GetView<StoryController> {
  MediaViewerPage({super.key});
  @override
  final controller = Get.find<StoryController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create story'),
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
                        final mediaType = controller.mediaType.value;
                        final file = controller.file.value;
                        if (mediaType == MediaType.image) {
                          return PhotoView(
                            imageProvider: FileImage(File(file!.path)),
                          );
                        } else if (mediaType == MediaType.video) {
                          return VideoPlayerWidget(
                            videoPlayerController:
                                VideoPlayerController.file(File(file!.path)),
                          );
                        } else {
                          return Container(); // Placeholder for unsupported media types
                        }
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
                          onFieldSubmitted: (value) => controller.uploadStory(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: const Color.fromARGB(255, 194, 192, 192),
                            filled: true,
                            hintText: "Add Caption ..",
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => controller.uploadStory(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.check_circle_outlined,
                                color: Colors.green,
                                size: 35,
                              ),
                              Text(
                                "Save".tr,
                                style: TextStyle(color: Colors.green),
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

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const VideoPlayerWidget({super.key, required this.videoPlayerController});

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.videoPlayerController;
    _controller.initialize().then((_) {
      setState(() {});
      _controller.play();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}

class MediaViewerController extends GetxController {}
