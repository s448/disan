import 'package:disan/Controller/timeline_tap_controller.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:disan/View/Widgets/post_widget.dart';
import 'package:disan/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimelinePage extends StatelessWidget {
  TimelinePage({
    super.key,
  });

  final userController = Get.put(UserController(), permanent: true);
  final controller = Get.put(TimelineTapController());

  @override
  Widget build(BuildContext context) {
    final currentUserModel = userController.curentUserModel;

    return Container(
        color: Colors.grey.shade300,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: InkWell(
                      onTap: () => Get.toNamed(Routes.createPost),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 32.0,
                          backgroundColor: Colors.blue,
                          backgroundImage: NetworkImage(
                            currentUserModel.profile.toString(),
                          ),
                        ),
                        title: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Text(
                            "Din a Dan .. Here".tr,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              StreamBuilder<List<DanModel>>(
                stream: controller.getTimelinePosts(),
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
                          usedInRatingPage: false,
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
            ],
          ),
        ));
  }
}
