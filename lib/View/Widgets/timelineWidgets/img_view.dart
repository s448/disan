import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImgView extends StatelessWidget {
  const ImgView({super.key});
  @override
  Widget build(BuildContext context) {
    final img = Get.arguments['img'];
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Image.network(
          img.toString(),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
