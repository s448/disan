import 'package:disan/Controller/ads_controller.dart';
import 'package:disan/Controller/clip_controller.dart';
import 'package:disan/Controller/local_storage.dart';
import 'package:disan/Controller/story_controller.dart';
import 'package:disan/Controller/timeline_tap_controller.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:disan/View/Screens/navbar/timeline/story/story_list.dart';
import 'package:disan/View/Widgets/timelineWidgets/post_widget.dart';
import 'package:disan/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class TimelinePage extends StatefulWidget {
  TimelinePage({
    super.key,
  });

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  @override
  void didChangeDependencies() async {
    await adsController.loadShopBanner();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    adsController.loadShopBanner();
    super.initState();
  }

  final userController = Get.put(UserController(), permanent: true);

  final controller = Get.put(TimelineTapController());

  final storyController = Get.put(StoryManageController(), permanent: true);

  final clipController = Get.put(ClipController(), permanent: true);

  final adsController = Get.find<AdsController>();

  final _prefs = Get.find<SharedPrefsController>();

  @override
  Widget build(BuildContext context) {
    final currentUserModel = userController.curentUserModel;

    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bckground.jpg"),
            fit: BoxFit.none,
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 8),
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
                      onTap: () {
                        if (_prefs.userAuthenticated()) {
                          adsController.showRewardedAd();
                          Get.toNamed(Routes.createPost);
                        } else {
                          customSnackbar("You are not authorized".tr,
                              "please sign in first".tr);
                        }
                      },
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
                            "Create a Den .. Here".tr,
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
              const SizedBox(height: 8),
              adsController.shopBannerLoaded.value
                  ? SizedBox(
                      height: 50,
                      child: StatefulBuilder(
                        builder: (context, setState) => AdWidget(
                          ad: adsController.shopBanner!,
                        ),
                      ),
                    )
                  : SizedBox(height: 0),
              const SizedBox(
                height: 3,
              ),
              StoryBar(),
              const SizedBox(
                height: 3,
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
                    return const SizedBox();
                  } else if (!snapshot.hasData) {
                    return const SizedBox();
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
