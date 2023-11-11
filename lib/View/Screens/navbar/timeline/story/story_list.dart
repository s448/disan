import 'dart:developer';

import 'package:disan/Controller/local_storage.dart';
import 'package:disan/Controller/story_controller.dart';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Model/story_model.dart';
import 'package:disan/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryBar extends StatelessWidget {
  StoryBar({super.key});
  final storyController = Get.put(StoryManageController(), permanent: true);
  final _prefs = Get.find<SharedPrefsController>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 70,
        width: Get.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (_prefs.userAuthenticated()) {
                        storyController.pickStoryMedia();
                      } else {
                        customSnackbar("You are not authorized".tr,
                            "please sign in first".tr);
                      }
                    },
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_sharp,
                            color: Colors.white,
                          ),
                          Text(
                            "Add",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            FutureBuilder(
                future: storyController.getGroupOfStories(),
                builder: (context, snapshot) {
                  List<List<Story>> userStoryList = snapshot.data ?? [];
                  print(
                      "stories here 888888888---------------------------5555555555555555552------------------------44444444444444444444444444444444444");
                  log(userStoryList.toString());
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: userStoryList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        List<Story> stories = userStoryList[index];

                        return InkWell(
                          onTap: () =>
                              Get.toNamed(Routes.viewStory, arguments: {
                            'stories': stories,
                          }),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CircleAvatar(
                              radius: 29,
                              backgroundColor: Colors.blue,
                              backgroundImage: NetworkImage(
                                stories[0].img.toString(),
                              ),
                            ),
                          ),
                        );
                      });
                })
          ],
        ),
      ),
    );
  }
}
