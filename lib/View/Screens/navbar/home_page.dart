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
              pinned: false,
              floating: true,
              // expandedHeight: Get.height * 0.15,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.search_circle,
                    size: 40,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.toNamed(Routes.profile,
                      arguments: {"uid": userController.currentUser!.uid}),
                  icon: const Icon(
                    CupertinoIcons.person,
                    size: 40,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(
                    text: 'Shop',
                    icon: Icon(Icons.shopping_bag_sharp),
                  ),
                  Tab(
                    text: 'Timeline',
                    icon: Icon(Icons.home),
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                children: [
                  ShopPage(),
                  TimelinePage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
