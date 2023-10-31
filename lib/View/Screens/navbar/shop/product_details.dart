import 'package:disan/View/Widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsPage extends StatelessWidget {
  ProductDetailsPage({super.key});
  final dan = Get.arguments['dan'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product details".tr),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: PostWidget(
        dan: dan,
        usedInCartPage: false,
        usedInOrdersPage: false,
        usedInRatingPage: false,
      ),
    );
  }
}
