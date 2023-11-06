import 'dart:developer';

import 'package:disan/Controller/clip_controller.dart';
import 'package:disan/Core/extension/url_launch_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reels_viewer/reels_viewer.dart';
import 'package:card_swiper/card_swiper.dart';

class ClipTimeline extends StatelessWidget {
  ClipTimeline({super.key});
  final controller = Get.put(ClipController(), permanent: true);
  final SwiperController swController = SwiperController();
  @override
  Widget build(BuildContext context) {
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
        // leading: IconButton(
        //   onPressed: () => controller.pickClipMedia(),
        //   icon: const Icon(
        //     Icons.add_a_photo_rounded,
        //     color: Colors.black,
        //   ),
        // ),
      ),
      body: controller.reels.isEmpty
          ? GetBuilder<ClipController>(
              init: ClipController(),
              builder: (context) {
                return Center(
                  child: Text("No clips for now".tr),
                );
              })
          : Stack(
              children: [
                ReelsViewer(
                  reelsList: controller.reels,
                  appbarTitle: 'Clips'.tr,
                  onShare: (url) {
                    UrlLauncherService.launch(url);
                  },
                  onLike: (url) => {
                    log('======> Clicked on follow <======'),
                    controller.likeReel(),
                  },
                  onFollow: () {
                    log('======> Clicked on follow <======');
                  },
                  onComment: (comment) {
                    controller.addComment(comment);
                  },
                  onClickMoreBtn: () {
                    log('======> Clicked on more option <======');
                  },
                  onClickBackArrow: () {
                    log('======> Clicked on back arrow <======');
                  },
                  onIndexChanged: (index) {
                    controller.changeIndex(index);
                  },
                  showProgressIndicator: true,
                  showVerifiedTick: false,
                  showAppbar: false,
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
