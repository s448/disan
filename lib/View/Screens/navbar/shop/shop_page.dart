import 'package:disan/Controller/shop_tap_controller.dart';
import 'package:disan/Core/constants/shop_categories.dart';
import 'package:disan/View/Widgets/grid_tile_tem.dart';
import 'package:disan/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopPage extends StatelessWidget {
  ShopPage({super.key});
  final controller = Get.put(ShopTapController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
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
                ),
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
                ),
              ),
            ),
            SizedBox(
              width: Get.width,
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(6),
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (var category in shopCategories)
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
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
          ],
        ),
      );
    });
  }
}
