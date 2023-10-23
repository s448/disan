import 'package:disan/Controller/user_controller.dart';
import 'package:disan/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimelinePage extends StatelessWidget {
  TimelinePage({super.key});
  final userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    final currentUserModel = userController.curentUserModel;
    print(currentUserModel.toJson());
    return
        // Obx(
        //   () =>
        SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            // height: Get.height * 0.23,
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
                        borderRadius: BorderRadius.circular(6.0)),
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
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(
              thickness: 1.5,
              color: Colors.black45,
            ),
          )
        ],
      ),
      // ),
    );
  }
}
