import 'package:disan/Controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);
  final controller = Get.put(UserController(), permanent: true);
  // Widget infoTemplate(infoItem, context) {
  //   return Row(
  //     children: [
  //       infoItem.icon,
  //       const SizedBox(
  //         width: 5,
  //       ),
  //       Container(
  //         width: MediaQuery.of(context).size.width - 50.0,
  //         padding: const EdgeInsets.all(5),
  //         child: RichText(
  //             text: TextSpan(style: const TextStyle(fontSize: 18), children: [
  //           TextSpan(
  //               text: infoItem.normalText,
  //               style: const TextStyle(color: Colors.white)),
  //           TextSpan(
  //               text: infoItem.boldText,
  //               style: const TextStyle(
  //                   color: Colors.white, fontWeight: FontWeight.bold))
  //         ])),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile".tr),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    image: DecorationImage(
                      image: NetworkImage(
                        controller.userModel.background ?? "",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 80),
                  child: CircleAvatar(
                    radius: 74.0,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 70.0,
                      backgroundImage: NetworkImage(
                        controller.userModel.profile ?? "",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              controller.userModel.name ?? "Unknown",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                controller.userModel.bio ?? "unknown",
                textAlign: TextAlign.center,
                maxLines: 4,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
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
                  onPressed: () {},
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
            ),
            Divider(
              thickness: 1,
              height: 10,
              color: Colors.grey[800],
            ),
          ],
        ),
      ),
    );
  }
}
