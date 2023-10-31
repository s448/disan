import 'package:disan/Controller/post_controller.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:disan/View/Widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});
  final controller = Get.find<PostController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cart".tr),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: GetBuilder<PostController>(
        builder: (c) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: controller.fetchCartItems(),
            builder: (context, snapshot) {
              print(controller.cart);

              if (controller.cart.isEmpty) {
                return Center(
                  child: Text("Cart is empty".tr),
                );
              } else if (snapshot.hasData) {
                final List<DanModel> dans = snapshot.data!;
                return ListView.builder(
                  itemCount: dans.length,
                  itemBuilder: (context, index) => PostWidget(
                    dan: dans[index],
                    usedInCartPage: true,
                    usedInOrdersPage: false,
                    usedInRatingPage: false,
                  ),
                );
              } else if (snapshot.hasError) {
                // print(snapshot.error.toString());
                return Text('error: ${snapshot.error}');
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
