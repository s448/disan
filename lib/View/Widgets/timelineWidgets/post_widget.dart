// import 'package:disan/Controller/audio_player_Controller.dart';
import 'package:disan/Controller/local_storage.dart';
import 'package:disan/Controller/post_controller.dart';
import 'package:disan/Controller/timeline_tap_controller.dart';
import 'package:disan/Core/extension/time_difference.dart';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:disan/View/Widgets/timelineWidgets/popup_menu_widget.dart';
import 'package:disan/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class PostWidget extends StatelessWidget {
  PostWidget({
    super.key,
    required this.dan,
    required this.usedInCartPage,
    required this.usedInOrdersPage,
    required this.usedInRatingPage,
  });
  final DanModel dan;
  final bool usedInCartPage;
  final bool usedInOrdersPage;
  final bool usedInRatingPage;
  final controller = Get.put(TimelineTapController());
  // final audioContrller = Get.put(enterTheApp();ontroller());
  final postController = Get.put(PostController());
  final _prefs = Get.find<SharedPrefsController>();

  final DateTimeManager dateTimeManager = DateTimeManager();

  @override
  Widget build(BuildContext context) {
    bool isMerchant = dan.user!.type == "MERCHANT";
    // final player = postController.player;
    var ratingButton = InkWell(
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
                initialRating: dan.rating ?? 0.0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                  if (_prefs.userAuthenticated()) {
                    controller.ratePost(dan.id!);
                    Get.back();
                    Get.back();
                  } else {
                    customSnackbar(
                        "You are not authorized".tr, "please sign in first".tr);
                  }
                },
                child: Text("Save".tr),
              )
            ],
          )),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Text(
              "${dan.rating?.toStringAsFixed(1)}",
              style: const TextStyle(color: Colors.black),
            ),
            const Icon(
              Icons.star,
              color: Colors.black,
            ),
            Text("Rating".tr)
          ],
        ),
      ),
    );
    var commentsButton = Row(
      children: [
        IconButton(
          onPressed: () =>
              Get.toNamed(Routes.comments, arguments: {"dan": dan}),
          icon: const Icon(
            Icons.comment,
            color: Colors.blue,
          ),
        ),
        Text("${dan.comments?.length ?? 0}")
      ],
    );
    var incartpageConformorder = InkWell(
      onTap: () => postController.addRemoveOrderItem(dan),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
            Text(
              usedInOrdersPage ? "Back to cart".tr : "Confirm order".tr,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
    var inOrdersPageBackToCart = InkWell(
      onTap: () => postController.backToCart(dan.id),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
            Text(
              "Back to cart".tr,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
    int imgsLength = dan.imgs?.length ?? 0;
    var likeButton = Row(
      children: [
        IconButton(
          onPressed: () {
            postController.triggerLike(dan);
            controller.likePost(dan.id!);
          },
          icon: Icon(
            postController.getLikeStatus(dan)
                ? Ionicons.heart
                : Ionicons.heart_outline,
            color: Colors.blue,
          ),
        ),
        Text("${dan.likes}")
      ],
    );
    var postTrailing = Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(color: Colors.yellow, width: 2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            dateTimeManager.getTimeDifference(dan.date!, 15),
            style: TextStyle(color: Colors.white),
          ),
        ),
        PostPopUpMenu(
          dan: dan,
          isMe: postController.isItMyPost(dan),
        )
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.0), color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///
            ///if the post is a reshare show this rich text
            ///
            dan.isReDaned! && !usedInCartPage
                ? ShareSign(dan: dan)
                : const SizedBox(),
            const SizedBox(
              height: 6,
            ),

            ///
            ///user info row
            ///
            isMerchant
                ? SizedBox(
                    width: Get.width,
                    // height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: Get.width * 0.55,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: InkWell(
                              onTap: () => Get.toNamed(Routes.profile,
                                  arguments: {'uid': dan.user?.id ?? ""}),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: dan.user!.profile == ''
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: const Icon(
                                          Ionicons.person_circle_outline,
                                          color: Colors.grey,
                                          size: 50,
                                        ),
                                      )
                                    : Image.network(
                                        dan.user!.profile.toString(),
                                      ),
                              ),
                            ),
                            title: Text(dan.user!.name.toString()),
                            subtitle:
                                Text(dateTimeManager.getDateTime(dan.date!)),
                          ),
                        ),
                        SizedBox(width: 100, child: postTrailing),
                      ],
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(dateTimeManager.getDate(dan.date!)),
                          Text(dateTimeManager.getTime(dan.date!)),
                        ],
                      ),
                      SizedBox(
                        width: Get.width * 0.4,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () => Get.toNamed(Routes.profile,
                                  arguments: {'uid': dan.user?.id ?? ""}),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: dan.user!.profile == ''
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: const Icon(
                                          Ionicons.person_circle_outline,
                                          color: Colors.grey,
                                          size: 50,
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 32.0,
                                        backgroundColor: Colors.blue,
                                        backgroundImage: NetworkImage(
                                          dan.user!.profile.toString(),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              dan.user!.name.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      postTrailing,
                    ],
                  ),
            const SizedBox(
              height: 15.0,
            ),

            ///
            ///description
            ///
            dan.withRecord == true
                ? InkWell(
                    onTap: () async {
                      postController.triggerPlayBtn();
                      try {
                        await postController.triggerSource(dan.description);
                      } catch (e) {
                        // print("---------------");
                        // print(e);
                      }
                    },
                    child: Obx(() {
                      return Icon(
                        postController.getPlayBtnStatus()
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 40,
                        color: postController.getPlayBtnStatus()
                            ? Colors.red
                            : Colors.blue,
                      );
                    }),
                  )
                : Text(
                    dan.description ?? "",
                    textAlign: TextAlign.start,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
            const SizedBox(
              height: 15.0,
            ),

            ///
            ///images
            ///
            imgsLength == 3
                ? SizedBox(
                    child: StaggeredGrid.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      children: [
                        StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 2,
                          child: InkWell(
                            onTap: () => Get.toNamed(Routes.imgview,
                                arguments: {"img": dan.imgs![0]}),
                            child: Image.network(
                              dan.imgs![0],
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 1,
                          child: InkWell(
                            onTap: () => Get.toNamed(Routes.imgview,
                                arguments: {"img": dan.imgs![1]}),
                            child: Image.network(
                              dan.imgs![1],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 1,
                          child: InkWell(
                            onTap: () => Get.toNamed(Routes.imgview,
                                arguments: {"img": dan.imgs![2]}),
                            child: Image.network(
                              dan.imgs![2],
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : imgsLength == 2
                    ? SizedBox(
                        child: StaggeredGrid.count(
                          crossAxisCount: 4,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          children: [
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 2,
                              child: InkWell(
                                onTap: () => Get.toNamed(Routes.imgview,
                                    arguments: {"img": dan.imgs![0]}),
                                child: Image.network(
                                  dan.imgs![0],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 2,
                              child: InkWell(
                                onTap: () => Get.toNamed(Routes.imgview,
                                    arguments: {"img": dan.imgs![1]}),
                                child: Image.network(
                                  dan.imgs![1],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : imgsLength == 1
                        ? InkWell(
                            onTap: () => Get.toNamed(Routes.imgview,
                                arguments: {"img": dan.imgs![0]}),
                            child: Image.network(
                              dan.imgs![0],
                              fit: BoxFit.cover,
                            ),
                          )
                        : const SizedBox(),
            const Divider(
              thickness: 1.5,
            ),

            usedInCartPage
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //first position
                      InCartWidgetRemoveFromCart(
                          postController: postController, dan: dan),
                      //second pos
                      commentsButton,
                      //third pos
                      incartpageConformorder
                    ],
                  )
                : usedInOrdersPage
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //first position
                          InOrdersWidgetRemoveFromOrders(
                              postController: postController, dan: dan),
                          //second pos
                          commentsButton,
                          //third pos
                          inOrdersPageBackToCart
                        ],
                      )
                    : usedInRatingPage
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ratingButton,
                              commentsButton,
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text("${dan.raters!.length} Rater".tr),
                              ),
                            ],
                          )
                        : isMerchant
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ratingButton,
                                  commentsButton,
                                  AddToCartButton(
                                      postController: postController, dan: dan),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  likeButton,
                                  commentsButton,
                                  shareButton(),
                                ],
                              )
          ],
        ),
      ),
    );
  }

  InkWell shareButton() {
    return InkWell(
      onTap: () {
        if (_prefs.userAuthenticated()) {
          controller.redanPost(dan);
        } else {
          customSnackbar(
              "You are not authorized".tr, "please sign in first".tr);
        }
      },
      child: const Column(
        children: [
          Icon(
            CupertinoIcons.arrow_turn_up_right,
            color: Colors.blue,
          ),
          Text(
            "ReDen",
          ),
        ],
      ),
    );
  }
}

class InCartWidgetRemoveFromCart extends StatelessWidget {
  const InCartWidgetRemoveFromCart({
    super.key,
    required this.postController,
    required this.dan,
  });

  final PostController postController;
  final DanModel dan;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => postController.addRemoveCartItem(dan.id),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              "Delete".tr,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class InOrdersWidgetRemoveFromCart extends StatelessWidget {
  const InOrdersWidgetRemoveFromCart({
    super.key,
    required this.postController,
    required this.dan,
  });

  final PostController postController;
  final DanModel dan;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => postController.addRemoveOrderItem(dan),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              "Delete".tr,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class InOrdersWidgetRemoveFromOrders extends StatelessWidget {
  const InOrdersWidgetRemoveFromOrders({
    super.key,
    required this.postController,
    required this.dan,
  });

  final PostController postController;
  final DanModel dan;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => postController.removeFromOrders(dan.id!),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              "Delete".tr,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class AddToCartButton extends StatelessWidget {
  AddToCartButton({
    super.key,
    required this.postController,
    required this.dan,
  });

  final PostController postController;
  final DanModel dan;
  final _prefs = Get.find<SharedPrefsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return InkWell(
        onTap: () {
          if (_prefs.userAuthenticated()) {
            postController.addRemoveCartItem(dan.id!);
          } else {
            customSnackbar(
                "You are not authorized".tr, "please sign in first".tr);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
              Text(
                postController.isAddedToCart(dan.id!)
                    ? "Added"
                    : "Add to cart".tr,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class ShareSign extends StatelessWidget {
  const ShareSign({
    super.key,
    required this.dan,
  });

  final DanModel dan;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: dan.reDanner?.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          TextSpan(
              text: " Shared this Den:".tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ))
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
