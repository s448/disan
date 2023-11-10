import 'package:disan/Controller/clip_controller.dart';
import 'package:disan/Core/extension/time_difference.dart';
import 'package:disan/Model/clip_model.dart';
import 'package:disan/View/Widgets/reelsWidgets/more_options.dart';
import 'package:disan/View/Widgets/reelsWidgets/showbottomsheetmodal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class OptionsScreen extends StatelessWidget {
  OptionsScreen({super.key, required this.clipModel});
  final controller = Get.put(ClipController());
  final ClipModel clipModel;
  final DateTimeManager dateTimeManager = DateTimeManager();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 110),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(
                          clipModel.user!.profile.toString(),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        clipModel.user!.name ?? "unknown".tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 15),
                      TextButton(
                        onPressed: () =>
                            controller.followUser(clipModel.user!.id ?? ""),
                        child: Text(
                          'Follow'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    clipModel.caption.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              Obx(() {
                var likers = controller.isLiked.value
                    ? clipModel.likers!.length + 1
                    : clipModel.likers!.length;
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(color: Colors.yellow),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        dateTimeManager.getTimeDifference(clipModel.date!),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => controller.likeReel(clipModel.id ?? ""),
                      child: controller.isLiked.value
                          ? const Icon(
                              Ionicons.heart,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_outline,
                              color: Colors.white,
                            ),
                    ),
                    Text(
                      likers.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => CommentsPageBody(
                          controller: controller,
                          clipId: clipModel.id ?? "",
                          comments: clipModel.comments ?? [],
                        ),
                      ),
                      child: const Icon(
                        Icons.comment_rounded,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      clipModel.comments!.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () => controller.shareReel(
                          clipModel.caption, clipModel.media),
                      child: Transform(
                        transform: Matrix4.rotationZ(5.8),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    ClipMoreOptionsButton(
                      isMe: controller.isMe(clipModel.user!.id!),
                      clip: clipModel,
                    )
                  ],
                );
              })
            ],
          ),
        ],
      ),
    );
  }
}
