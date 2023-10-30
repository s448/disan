import 'package:disan/Controller/audio_player_Controller.dart';
import 'package:disan/Controller/post_controller.dart';
import 'package:disan/Controller/timeline_tap_controller.dart';
import 'package:disan/Core/extension/time_difference.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:disan/View/Widgets/popup_menu_widget.dart';
import 'package:disan/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

// ignore: must_be_immutable
class PostWidget extends StatelessWidget {
  PostWidget(
      {super.key,
      required this.dan,
      required this.usedInCartPage,
      required this.usedInOrdersPage});
  final DanModel dan;
  final bool usedInCartPage;
  final bool usedInOrdersPage;
  final controller = Get.put(TimelineTapController());
  final audioContrller = Get.put(AudioController());
  final postController = Get.put(PostController());

  DateTimeManager dateTimeManager = DateTimeManager();

  @override
  Widget build(BuildContext context) {
    bool isMerchant = dan.user!.type == "MERCHANT";
    // final player = postController.player;
    var RatingButton = InkWell(
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
                allowHalfRating: true,
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
                  controller.ratePost(dan.id!);
                  Get.back();
                  Get.back();
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
              "${dan.rating}",
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
    var CommentsButton = Row(
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
    var InCartPage_ConformOrder = InkWell(
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
    int imgsLength = dan.imgs!.length;
    var LikeButton = Row(
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0), color: Colors.white),
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
            !isMerchant
                ? ListTile(
                    trailing: SizedBox(
                      width: 110,
                      child: Row(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(color: Colors.yellow),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(dateTimeManager
                                  .getTimeDifference(dan.date!))),
                          PostPopUpMenu(
                            dan: dan,
                            isMe: postController.isItMyPost(dan.user!.id!),
                          )
                        ],
                      ),
                    ),
                    leading: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Image.network(
                        dan.user!.profile.toString(),
                      ),
                    ),
                    title: Text(dan.user!.name.toString()),
                    subtitle: Text(dateTimeManager.getDateTime(dan.date!)),
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
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 32.0,
                            backgroundColor: Colors.blue,
                            backgroundImage: NetworkImage(
                              dan.user!.profile.toString(),
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
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(color: Colors.yellow),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(dateTimeManager
                                  .getTimeDifference(dan.date!))),
                          PostPopUpMenu(
                            dan: dan,
                            isMe: postController.isItMyPost(dan.user!.id!),
                          )
                        ],
                      ),
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
                        print("----------------------START-----------------");
                        await postController.triggerSource(dan.description);
                      } catch (e) {
                        print("---------------");
                        print(e);
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
            dan.imgs!.isNotEmpty
                ? SizedBox(
                    child: StaggeredGrid.count(
                      crossAxisCount: imgsLength == 3
                          ? 4
                          : imgsLength == 2
                              ? 2
                              : 1,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      children: [
                        StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 2,
                          child: Image.network(
                            dan.imgs![0],
                            fit: BoxFit.cover,
                          ),
                        ),
                        dan.imgs!.length > 1
                            ? StaggeredGridTile.count(
                                crossAxisCellCount: 2,
                                mainAxisCellCount: 1,
                                child: Image.network(
                                  dan.imgs![1],
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const SizedBox(),
                        dan.imgs!.length > 2
                            ? StaggeredGridTile.count(
                                crossAxisCellCount: 2,
                                mainAxisCellCount: 1,
                                child: Image.network(
                                  dan.imgs![2],
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const SizedBox(),
                      ],
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
                      CommentsButton,
                      //third pos
                      InCartPage_ConformOrder
                    ],
                  )
                : usedInOrdersPage
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //first position
                          InOrdersWidgetRemoveFromCart(
                              postController: postController, dan: dan),
                          //second pos
                          CommentsButton,
                          //third pos
                          inOrdersPageBackToCart
                        ],
                      )
                    : isMerchant
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RatingButton,
                              CommentsButton,
                              AddToCartButton(
                                  postController: postController, dan: dan),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              LikeButton,
                              CommentsButton,
                              shareButton(),
                            ],
                          )

            ///
            ///recation row
            ///
            // usedInCartPage
            //     ? Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceAround,
            //         children: [
            //           //remove from cart
            //           InCartWidgetRemoveFromCart(
            //               postController: postController, dan: dan),
            //           //no of comments
            //           CommentsButton,
            //           //confirm order
            //           InCartPage_ConformOrder
            //         ],
            //       )
            //     : Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceAround,
            //         children: [
            //           ///
            //           ///rating
            //           ///
            //           isMerchant
            //               ? RatingButton
            //               //like button
            //               : LikeButton,
            //           //comments
            //           CommentsButton,
            //           //add to cart
            //           isMerchant
            //               ? AddToCartButton(
            //                   postController: postController, dan: dan)
            //               //share
            //               : shareButton()
            //         ],
            //       ),
          ],
        ),
      ),
    );
  }

  InkWell shareButton() {
    return InkWell(
      onTap: () => controller.redanPost(dan),
      child: const Column(
        children: [
          Icon(
            CupertinoIcons.arrow_turn_up_right,
            color: Colors.blue,
          ),
          Text(
            "ReDan",
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

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.postController,
    required this.dan,
  });

  final PostController postController;
  final DanModel dan;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return InkWell(
        onTap: () => postController.addRemoveCartItem(dan.id),
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
            text: dan.reDanner,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          TextSpan(
              text: " Shared this Dan:".tr,
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
