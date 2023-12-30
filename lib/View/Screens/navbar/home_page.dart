import 'package:disan/Controller/user_controller.dart';
import 'package:disan/View/Screens/navbar/shop/shop_page.dart';
import 'package:disan/View/Screens/navbar/timeline/timeline_page.dart';
import 'package:disan/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final userController = Get.put(UserController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                systemNavigationBarColor: Colors.transparent, // Navigation bar
                statusBarColor: Colors.transparent, // Status bar
              ),
              title: const Text('Disan'),
              pinned: true,
              floating: false,
              // expandedHeight: Get.height * 0.15,
              actions: [
                IconButton(
                  onPressed: () => Get.toNamed(Routes.search),
                  icon: const Icon(
                    CupertinoIcons.search_circle,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                // userController.curentUserModel.id == "" ||
                //         userController.curentUserModel.id == null
                //     ? const SizedBox()
                //     :
                IconButton(
                  onPressed: () => Get.toNamed(Routes.lang),
                  icon: const Icon(
                    Icons.translate_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
              bottom: TabBar(
                tabs: [
                  Tab(
                    text: 'Timeline'.tr,
                    icon: const Icon(Icons.home),
                  ),
                  Tab(
                    text: 'Shop'.tr,
                    icon: const Icon(Icons.shopping_bag_sharp),
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                children: [
                  TimelinePage(),
                  ShopPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
