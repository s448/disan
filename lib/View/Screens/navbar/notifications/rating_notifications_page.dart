import 'package:disan/Controller/notifications_page_controller.dart';
import 'package:disan/Core/extension/time_difference.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:disan/View/Widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyRatingsPage extends StatelessWidget {
  MyRatingsPage({super.key});
  final controller = Get.find<NotificationsPageController>();
  final DateTimeManager dateTimeManager = DateTimeManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text("My Ratings".tr),
        centerTitle: true,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.blue,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 18,
            ),
            SizedBox(
              child: StreamBuilder<List<DanModel>>(
                stream: controller.getMyPosts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final posts = snapshot.data!;
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: posts.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (index >= posts.length) {
                          return Container();
                        }
                        final dan = posts[index];
                        return PostWidget(
                          dan: dan,
                          usedInCartPage: false,
                          usedInOrdersPage: false,
                          usedInRatingPage: true,
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
