import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Model/clip_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClipMoreOptionsButton extends StatelessWidget {
  ClipMoreOptionsButton({super.key, required this.isMe, required this.clip});

  final bool isMe;
  final ClipModel clip;
  final controller = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_vert_rounded,
        color: Colors.white,
      ),
      iconSize: 35,
      itemBuilder: (BuildContext context) {
        var list = <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: "1",
            child: Column(
              children: [
                const Icon(Icons.save_alt_outlined),
                Text("Save".tr),
              ],
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<String>(
            value: '2',
            child: Column(
              children: [const Icon(Icons.add), Text("Follow".tr)],
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<String>(
            value: '3',
            child: Column(
              children: [const Icon(Icons.volume_mute_sharp), Text("Mute".tr)],
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<String>(
            value: '4',
            child: Column(
              children: [const Icon(Icons.block), Text("Block".tr)],
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<String>(
            value: '5',
            enabled: isMe,
            child: Column(
              children: [const Icon(Icons.delete), Text("Delete".tr)],
            ),
          ),
        ];
        return list;
      },
      onSelected: (String result) async {
        await controller.makePopupAction(
          result,
          clip.user!.id!,
          clip.id!,
          [clip.media ?? ""],
          "clip",
        );
      },
    );
  }
}
