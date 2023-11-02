import 'dart:developer';

import 'package:disan/Controller/clip_controller.dart';
import 'package:disan/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reels_viewer/reels_viewer.dart';

class ClipTimeline extends StatelessWidget {
  ClipTimeline({super.key});
  final controller = Get.put(ClipController());
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
        leading: IconButton(
          onPressed: () => controller.pickClipMedia(),
          icon: const Icon(
            Icons.add_a_photo_rounded,
            color: Colors.black,
          ),
        ),
      ),
      body: controller.reels.isEmpty
          ? Center(
              child: Text("No clips for now".tr),
            )
          : ReelsViewer(
              reelsList: controller.reels,
              appbarTitle: 'Clips'.tr,
              onShare: (url) {
                log('Shared reel url ==> $url');
              },
              onLike: (url) {
                log('Liked reel url ==> $url');
              },
              onFollow: () {
                log('======> Clicked on follow <======');
              },
              onComment: (comment) {
                log('Comment on reel ==> $comment');
              },
              onClickMoreBtn: () {
                log('======> Clicked on more option <======');
              },
              onClickBackArrow: () {
                log('======> Clicked on back arrow <======');
              },
              onIndexChanged: (index) {
                log('======> Current Index ======> $index <========');
              },
              showProgressIndicator: true,
              showVerifiedTick: false,
              showAppbar: false,
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
