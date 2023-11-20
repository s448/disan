import 'package:disan/Model/clip_model.dart';
import 'package:disan/View/Widgets/reelsWidgets/reel_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewClipPage extends StatelessWidget {
  ViewClipPage({
    super.key,
  });
  final ClipModel clip = Get.arguments['clip'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: ContentScreen(clipModel: clip),
    );
  }
}
