import 'package:disan/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                systemNavigationBarColor: Colors.transparent, // Navigation bar
                statusBarColor: Colors.transparent, // Status bar
              ),
              title: const Text('Disan'),
              pinned: false,
              floating: false,
              expandedHeight: Get.height * 0.15,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.search_circle,
                    size: 40,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.toNamed(Routes.profile),
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
            const SliverFillRemaining(
              child: TabBarView(
                children: [
                  Center(child: Text('Tab 1 Content')),
                  Center(child: Text('Tab 2 Content')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
