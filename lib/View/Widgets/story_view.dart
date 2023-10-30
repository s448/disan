import 'package:disan/Model/story_model.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StoryViewPage extends StatelessWidget {
  StoryViewPage({super.key, required this.story});
  final Story story;
  final controller = StoryController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryView(
        controller: controller,
        storyItems: [
          for (var item in story.mediaList!)
            StoryItem.pageVideo(
              item,
              controller: controller,
              imageFit: BoxFit.cover,
            )
        ],
      ),
    );
  }
}
