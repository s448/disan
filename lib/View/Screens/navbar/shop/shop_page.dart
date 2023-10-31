import 'package:disan/Controller/post_controller.dart';
import 'package:disan/Controller/shop_tap_controller.dart';
import 'package:disan/Core/constants/shop_categories.dart';
import 'package:disan/View/Widgets/grid_tile_tem.dart';
import 'package:disan/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopPage extends StatelessWidget {
  ShopPage({super.key});
  final controller = Get.put(ShopTapController(), permanent: true);
  final postController = Get.put(PostController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Trending profile".tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.yellow),
                  ),
                ),
                // const SizedBox(height: 6),
                // ignore: invalid_use_of_protected_member
                controller.trendingProfiles.value.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: Get.width,
                        height: Get.height * 0.2,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          // ignore: invalid_use_of_protected_member
                          itemCount: controller.trendingProfiles.value.length,
                          itemBuilder: (context, index) {
                            final profile =
                                // ignore: invalid_use_of_protected_member
                                controller.trendingProfiles.value[index];
                            final profilePicUrl = profile.profile;
                            final uid = profile.id;
                            final name = profile.name;
                            return InkWell(
                              onTap: () => Get.toNamed(Routes.profile,
                                  arguments: {"uid": uid}),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                width: Get.width / 2.3,
                                height: Get.height / 6.5,
                                child: GridTileItem(
                                  networking: true,
                                  name: name.toString(),
                                  img: profilePicUrl.toString(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Categories".tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blue),
                  ),
                ),
                SizedBox(
                  width: Get.width,
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(1),
                    mainAxisSpacing: 2,
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (var category in shopCategories)
                        Container(
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          width: Get.width / 2,
                          // height: Get.height / 6,
                          child: GridTileItem(
                            networking: false,
                            name: category['name'].toString(),
                            img:
                                "assets/categories/${category['img'].toString()}.jpg",
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Best selling".tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.red,
                    ),
                  ),
                ),
                // const SizedBox(height: 6),
                // ignore: invalid_use_of_protected_member
                controller.bestSellingProducts.value.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: Get.width,
                        height: Get.height * 0.2,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          // ignore: invalid_use_of_protected_member
                          itemCount:
                              controller.bestSellingProducts.value.length,
                          itemBuilder: (context, index) {
                            final product =
                                // ignore: invalid_use_of_protected_member
                                controller.bestSellingProducts.value[index];
                            final productImgUrl = product.imgs!.length != 0
                                ? product.imgs![0]
                                : "";
                            final name = product.description;

                            return InkWell(
                              onTap: () => Get.toNamed(Routes.productDetails,
                                  arguments: {"dan": product}),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                width: Get.width / 2.3,
                                height: Get.height / 6.5,
                                child: GridTileItem(
                                  networking: true,
                                  name: name.toString(),
                                  img: productImgUrl.toString(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                const SizedBox(height: 6),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 5,
            child: InkWell(
              onTap: () => Get.toNamed(Routes.cart),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                width: Get.width * 0.38,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Cart".tr,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.shopping_cart,
                      color: Colors.red,
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 5,
            child: InkWell(
              onTap: () => Get.toNamed(Routes.orders),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.yellow),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                width: Get.width * 0.38,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Orders".tr,
                      style: const TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.shopping_cart,
                      color: Colors.yellow,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
