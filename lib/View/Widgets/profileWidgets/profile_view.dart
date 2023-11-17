import 'dart:developer';

import 'package:disan/Controller/story_controller.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Core/extension/url_launch_service.dart';
import 'package:disan/View/Widgets/profileWidgets/active_dans_grid_view.dart';
import 'package:disan/View/Widgets/profileWidgets/shop_location.dart';
import 'package:disan/View/Widgets/profileWidgets/user_info_tile.dart';
import 'package:disan/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class ProfilePageTemp extends StatefulWidget {
  const ProfilePageTemp({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  State<ProfilePageTemp> createState() => _ProfilePageTempState();
}

class _ProfilePageTempState extends State<ProfilePageTemp> {
  @override
  void initState() {
    controller.getMyActiveDans(widget.userId);
    super.initState();
  }

  @override
  void dispose() {
    controller.myActiveDans.clear();
    super.dispose();
  }

  final controller = Get.find<UserController>();

  final storyController = Get.find<StoryManageController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.getUserModel(widget.userId),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final userData = controller.userModel;
        log(userData.toJson().toString());
        bool isUser = userData.type == "USER";
        bool isMe = widget.userId == controller.currentUser!.uid;
        return Container(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          // padding: const EdgeInsets.only(left: 6, right: 6),
          constraints: const BoxConstraints.expand(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Stack(
                  alignment: isUser ? Alignment.topCenter : Alignment.topLeft,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        image: DecorationImage(
                          image: NetworkImage(
                            userData.background ?? "",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: const EdgeInsets.only(top: 60),
                        child: CircleAvatar(
                          radius: 74.0,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 70.0,
                            backgroundImage: NetworkImage(
                              userData.profile ?? "",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                      child: Text(
                        userData.name ?? "unknown".tr,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                !isUser
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => Get.bottomSheet(
                              Container(
                                height: Get.height * 0.3,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RatingBar.builder(
                                      initialRating: userData.rating ?? 0.0,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        controller.rate.value = rating;
                                        controller.update();
                                      },
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        controller.rateShop(userData.id!);
                                        Get.back();
                                        Get.back();
                                      },
                                      child: Text("Save".tr),
                                    )
                                  ],
                                )),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 9),
                              child: RatingBarIndicator(
                                rating: userData.rating ?? 0.0,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20.0,
                                direction: Axis.horizontal,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                userData.bio == "" || userData.bio == null
                    ? const SizedBox(
                        height: 5,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          userData.bio.toString(),
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                !isUser && userData.lat != 0.0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ShopLocationWidget(
                            lat: userData.lat ?? 0.0,
                            long: userData.long ?? 0.0),
                      )
                    : const SizedBox(),
                !isUser
                    ? Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          for (var c in userData.categories ?? [])
                            Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                c.toString().tr,
                                textAlign: TextAlign.start,
                              ),
                            ),
                        ],
                      )
                    : const SizedBox(),
                isMe
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => storyController.pickStoryMedia(),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[800]),
                            child: Row(
                              children: [
                                const Icon(Icons.add_circle_rounded),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text('Add to story'.tr)
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                Get.toNamed(Routes.completeUserInfo),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[900]),
                            child: Row(
                              children: [
                                const Icon(Icons.edit),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text('Edit profile'.tr)
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Divider(
                    thickness: 1,
                    height: 10,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      children: [
                        userData.whatsappNumber!.isEmpty
                            ? const SizedBox()
                            : InkWell(
                                onTap: () => UrlLauncherService.launch(
                                  'https://api.whatsapp.com/send?phone=${userData.whatsappNumber}&text=${Uri.encodeComponent("")}',
                                ),
                                child: UserInfoTile(
                                  ic: const Icon(
                                    Ionicons.logo_whatsapp,
                                    color: Colors.green,
                                    size: 32,
                                  ),
                                  title: "".tr,
                                  num: userData.whatsappNumber.toString(),
                                ),
                              ),
                        SizedBox(height: 14),
                        UserInfoTile(
                          ic: const Icon(
                            Icons.podcasts,
                            color: Colors.black,
                            size: 32,
                          ),
                          title: "Follower".tr,
                          num: controller.getMyFollowers().toString(),
                        ),
                        const SizedBox(height: 8),
                        UserInfoTile(
                          ic: const Icon(
                            Icons.read_more_sharp,
                            color: Colors.black,
                            size: 32,
                          ),
                          title: "Following".tr,
                          num: controller.getMyFollowing().toString(),
                        ),
                        const SizedBox(height: 8),
                        UserInfoTile(
                          ic: const Icon(
                            Icons.post_add,
                            color: Colors.black,
                            size: 32,
                          ),
                          title: "Active dan".tr,
                          num: controller.activeDansLength.toString(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => controller.changeActiveDansView(),
                          child: Container(
                            width: Get.width * 0.45,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: controller.isListView.value
                                  ? Colors.blue
                                  : Colors.transparent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text("List View".tr)),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => controller.changeActiveDansView(),
                          child: Container(
                            width: Get.width * 0.45,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: controller.isListView.value
                                  ? Colors.transparent
                                  : Colors.blue,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text("Grid view".tr)),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 8),
                controller.activeDansLength == 0
                    ? Center(
                        child: Text("No active dans".tr),
                      )
                    : Obx(
                        () {
                          return ActiveDansGridView(
                            activeDans: controller.myActiveDans,
                            isGListView: controller.isListView.value,
                          );
                        },
                      ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
