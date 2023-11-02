import 'package:disan/Controller/story_controller.dart';
import 'package:disan/Core/extension/time_difference.dart';
import 'package:disan/Model/story_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_view/story_view.dart';

class StoryViewPage extends StatelessWidget {
  StoryViewPage({super.key});
  final storyController = Get.find<StoryManageController>();
  final controller = StoryController();
  final List<Story> stories = Get.arguments['stories'];
  final DateTimeManager dtManager = DateTimeManager();
  @override
  Widget build(BuildContext context) {
    print(stories.length);
    print(stories);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        title: Text(
          stories[0].user!.name!,
          style: const TextStyle(color: Colors.white),
        ),
        // title: ListTile(
        //   title: Text(stories[0].user!.name!),
        //   subtitle: Text(dtManager.getTime(stories[0].date!)),
        // ),
      ),
      body: StoryView(
        onComplete: () => Get.back(),
        storyItems: [
          StoryItem.pageImage(
            shown: true,
            url:
                "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
            caption: "Still sampling",
            controller: controller,
          ),
          StoryItem.pageImage(
            shown: true,
            url: stories[0].img!,
            caption: stories[0].caption,
            controller: controller,
          ),
        ],
        controller: controller,
      ),
    );
  }
}
