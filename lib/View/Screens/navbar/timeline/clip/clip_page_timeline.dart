import 'package:card_swiper/card_swiper.dart';
import 'package:disan/Controller/clip_controller.dart';
import 'package:disan/Model/clip_model.dart';
import 'package:disan/View/Widgets/reelsWidgets/reel_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reels_viewer/reels_viewer.dart';

class ClipTimeline extends StatelessWidget {
  ClipTimeline({super.key});
  final controller = Get.put(ClipController(), permanent: true);
  // final SwiperController swController = SwiperController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClipController>(
        // init: ClipController(),
        builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Clips".tr),
          centerTitle: true,
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Stack(
          children: [
            SafeArea(
              child: Stack(
                children: [
                  //We need swiper for every content

                  StreamBuilder<List<ClipModel>>(
                    stream: controller.getClips(),
                    builder: (context, snapshot) {
                      return Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return StreamBuilder<List<ClipModel>>(
                            stream: controller.getClips(),
                            builder: (context, snapshot) {
                              return ContentScreen(
                                clipModel: snapshot.data![index],
                              );
                            },
                          );
                        },
                        itemCount: snapshot.data!.length,
                        scrollDirection: Axis.vertical,
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              left: (Get.width / 2) - 75,
              child: Center(
                child: InkWell(
                  onTap: () => controller.pickClipMedia(),
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.blue,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Add Clip ".tr,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const Icon(
                            Icons.add_a_photo_outlined,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}

List<ReelModel> reelsList = [
  ReelModel(
      'https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-flowers-1173-large.mp4',
      'Darshan Patil',
      likeCount: 2000,
      isLiked: true,
      musicName: 'In the name of Love',
      reelDescription: "Life is better when you're laughing.",
      profileUrl:
          'https://opt.toiimg.com/recuperator/img/toi/m-69257289/69257289.jpg',
      commentList: [
        ReelCommentModel(
          comment: 'Nice...',
          userProfilePic:
              'https://opt.toiimg.com/recuperator/img/toi/m-69257289/69257289.jpg',
          userName: 'Darshan',
          commentTime: DateTime.now(),
        ),
        ReelCommentModel(
          comment: 'Superr...',
          userProfilePic:
              'https://opt.toiimg.com/recuperator/img/toi/m-69257289/69257289.jpg',
          userName: 'Darshan',
          commentTime: DateTime.now(),
        ),
        ReelCommentModel(
          comment: 'Great...',
          userProfilePic:
              'https://opt.toiimg.com/recuperator/img/toi/m-69257289/69257289.jpg',
          userName: 'Darshan',
          commentTime: DateTime.now(),
        ),
      ]),
  ReelModel(
    'https://assets.mixkit.co/videos/preview/mixkit-father-and-his-little-daughter-eating-marshmallows-in-nature-39765-large.mp4',
    'Rahul',
    musicName: 'In the name of Love',
    reelDescription: "Life is better when you're laughing.",
    profileUrl:
        'https://opt.toiimg.com/recuperator/img/toi/m-69257289/69257289.jpg',
  ),
  ReelModel(
    'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4',
    'Rahul',
  ),
];

final List<String> videos = [
  'https://assets.mixkit.co/videos/preview/mixkit-taking-photos-from-different-angles-of-a-model-34421-large.mp4',
  'https://assets.mixkit.co/videos/preview/mixkit-young-mother-with-her-little-daughter-decorating-a-christmas-tree-39745-large.mp4',
  'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4',
  'https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-sign-1232-large.mp4',
  'https://assets.mixkit.co/videos/preview/mixkit-winter-fashion-cold-looking-woman-concept-video-39874-large.mp4',
  'https://assets.mixkit.co/videos/preview/mixkit-womans-feet-splashing-in-the-pool-1261-large.mp4',
  'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4'
];
