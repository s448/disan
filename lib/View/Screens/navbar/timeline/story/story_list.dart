import 'package:disan/Controller/story_controller.dart';
import 'package:disan/Model/story_model.dart';
import 'package:disan/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryBar extends StatelessWidget {
  StoryBar({super.key});
  final storyController = Get.put(StoryManageController(), permanent: true);

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
                    onTap: () => storyController.pickStoryMedia(),
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.cyan,
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
                  print(userStoryList);
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
                              backgroundColor: Colors.cyan,
                              backgroundImage: NetworkImage(
                                stories[0].img.toString(),
                              ),
                              // child: Column(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   crossAxisAlignment:
                              //       CrossAxisAlignment.center,
                              //   children: [
                              //     Text(
                              //       stories[0].user!.name!,
                              //       style: const TextStyle(
                              //           color: Colors.white, fontSize: 8),
                              //     )
                              //   ],
                              // ),
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
