import 'package:disan/Model/dan_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class PostWidget extends StatelessWidget {
  PostWidget({super.key, required this.dan});
  final DanModel dan;
  final formatter = DateFormat('yyyy-MM-dd hh:mm');

  @override
  Widget build(BuildContext context) {
    bool isMerchant = dan.user!.type == "MERCHANT";
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height: Get.height * 0.5,
        width: Get.width,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0), color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 32.0,
                backgroundColor: Colors.blue,
                backgroundImage: NetworkImage(
                  dan.user!.profile.toString(),
                ),
              ),
              title: Text(dan.user!.name.toString()),
              subtitle: Text(formatter.format(dan.date!.toDate())),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Text(
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
                    ? Row(
                        children: [
                          Text("${4.5}"),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                          )
                        ],
                      )
                    : Row(
                        children: [
                          IconButton(
                            onPressed: () {},
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
                      onPressed: () {
                        print(dan.description);
                        showModalBottomSheet<void>(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                              children: [
                                SizedBox(
                                    height: Get.height * 0.9,
                                    child: ListView.builder(
                                      itemCount: 2,
                                      itemBuilder: (context, index) => Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 20.0,
                                            backgroundColor: Colors.blue,
                                            backgroundImage: NetworkImage(
                                              dan.user!.profile.toString(),
                                            ),
                                          ),
                                          title: Text(
                                            dan.user!.name.toString(),
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          subtitle: Text(
                                            dan.description.toString(),
                                            maxLines: 3,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black54),
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            );
                          },
                        );
                      },
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
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Add to cart".tr,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.arrow_turn_up_right,
                          color: Colors.blue,
                        ),
                      )
              ],
            )
          ],
        ),
      ),
    );
  }
}
