import 'package:disan/Controller/timeline_tap_controller.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:disan/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:audioplayers/audioplayers.dart';

class PostWidget extends StatelessWidget {
  PostWidget({super.key, required this.dan});
  final DanModel dan;
  final date = DateFormat('yyyy-MM-dd');
  final time = DateFormat('hh:mm');
  final player = AudioPlayer();
  final _player = AudioCache();
  final controller = Get.put(TimelineTapController());

  @override
  Widget build(BuildContext context) {
    bool isMerchant = dan.user!.type == "MERCHANT";
    initializeDateFormatting();
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateTime customTimestamp =
        formatter.parse(dan.date!.toDate().toString());
    final DateTime targetDate = customTimestamp.add(const Duration(days: 15));
    final Duration difference = targetDate.difference(customTimestamp);
    final int days = difference.inDays;
    final int hours = difference.inHours.remainder(24);

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
            !isMerchant
                ? ListTile(
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(color: Colors.yellow),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text("$days:$hours")),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.more_vert_rounded)),
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
                    subtitle: Text(formatter.format(dan.date!.toDate())),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(date.format(dan.date!.toDate())),
                          Text(time.format(dan.date!.toDate())),
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
                              child: Text("$days:$hours")),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.more_vert_rounded)),
                        ],
                      ),
                    ],
                  ),
            const SizedBox(
              height: 15.0,
            ),
            dan.description.toString().isURL
                ? InkWell(
                    onTap: () async {
                      try {
                        var path = await controller.downloadFileToCache(
                            dan.description!, "3gpp");
                        print(path);
                        await player.play(AssetSource(path));
                      } catch (e) {
                        print("---------------");
                        print(e);
                      }
                    },
                    child: const Icon(
                      Icons.play_arrow,
                    ),
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
            SizedBox(
              child: StaggeredGrid.count(
                crossAxisCount: 4,
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
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1,
                    child: Image.network(
                      dan.imgs![1],
                      fit: BoxFit.cover,
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1,
                    child: Image.network(
                      dan.imgs![2],
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                isMerchant
                    ? Container(
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
                            const Text("Rating")
                          ],
                        ),
                      )
                    : Row(
                        children: [
                          IconButton(
                            onPressed: () => controller.likePost(dan.id!),
                            icon: const Icon(
                              Ionicons.heart_outline,
                              color: Colors.blue,
                            ),
                          ),
                          Text("${dan.likes}")
                        ],
                      ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () =>
                          Get.toNamed(Routes.comments, arguments: {"dan": dan}),
                      icon: const Icon(
                        Icons.comment,
                        color: Colors.blue,
                      ),
                    ),
                    Text("${dan.comments!.length}")
                  ],
                ),
                isMerchant
                    ? Container(
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
                              "Add to cart".tr,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Column(
                        children: [
                          Icon(
                            CupertinoIcons.arrow_turn_up_right,
                            color: Colors.blue,
                          ),
                          Text(
                            "ReDan",
                          ),
                        ],
                      )
              ],
            )
          ],
        ),
      ),
    );
  }
}
