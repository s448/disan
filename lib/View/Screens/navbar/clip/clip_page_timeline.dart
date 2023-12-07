import 'package:card_swiper/card_swiper.dart';
import 'package:disan/Controller/clip_controller.dart';
import 'package:disan/Controller/local_storage.dart';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Model/clip_model.dart';
import 'package:disan/View/Widgets/reelsWidgets/reel_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClipTimeline extends StatelessWidget {
  ClipTimeline({super.key});
  final controller = Get.put(ClipController());
  final _prefs = Get.find<SharedPrefsController>();
  // final SwiperController swController = SwiperController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClipController>(
        // init: ClipController(),
        builder: (context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   title: Text("Clips".tr),
        //   centerTitle: true,
        //   backgroundColor: Colors.grey.shade200,
        //   titleTextStyle: const TextStyle(
        //     color: Colors.black,
        //     fontSize: 18,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        body: Container(
          color: Colors.black,
          child: Stack(
            children: [
              SafeArea(
                child: Stack(
                  children: [
                    //We need swiper for every content

                    StreamBuilder<List<ClipModel>>(
                      stream: controller.getClips(),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return StreamBuilder<List<ClipModel>>(
                              stream: controller.getClips(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                return ContentScreen(
                                  clipModel: snapshot.data![index],
                                );
                              },
                            );
                          },
                          itemCount: snapshot.data!.length,
                          scrollDirection: Axis.vertical,
                        );
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: Get.height * 0.1,
                left: (Get.width / 2) - 75,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      if (_prefs.userAuthenticated()) {
                        controller.pickClipMedia();
                      } else {
                        customSnackbar("You are not authorized".tr,
                            "please sign in first".tr);
                      }
                    },
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.blue,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Add Clip ".tr,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const Icon(
                              Icons.add_a_photo_outlined,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.black26,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Clips'.tr,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
