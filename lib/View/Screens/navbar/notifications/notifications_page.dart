import 'package:disan/Controller/notifications_page_controller.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Core/extension/time_difference.dart';
import 'package:disan/Model/notification_model.dart';
import 'package:disan/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});
  final controller = Get.put(NotificationsPageController(), permanent: true);
  final DateTimeManager dateTimeManager = DateTimeManager();
  final userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications".tr),
        centerTitle: true,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 18,
            ),
            userController.curentUserModel.type == "MERCHANT"
                ? SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () => Get.toNamed(Routes.myOrders),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: Get.width * 0.4,
                              height: Get.height * 0.08,
                              child: Center(
                                child: Text(
                                  "Orders".tr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => Get.toNamed(Routes.myRatings),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: Get.width * 0.4,
                              height: Get.height * 0.08,
                              child: Center(
                                child: Text(
                                  "Rating".tr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 18,
            ),
            SizedBox(
              child: StreamBuilder(
                stream: controller.getNotifications(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final notifications = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        NotificationModel notification = notifications[index];
                        return InkWell(
                          onTap: () {
                            if (notification.topic == "connection") {
                              return;
                            } else {
                              Get.toNamed(Routes.productDetails,
                                  arguments: {'dan': notification.dan});
                            }
                          },
                          child: ListTile(
                            title: Text(notification.title ?? ''),
                            subtitle: Column(
                              children: [
                                Text(notification.body ?? ''),
                                Row(
                                  children: [
                                    notification.topic == "connection"
                                        ? TextButton(
                                            onPressed: () =>
                                                controller.acceptConnection(
                                                  notification.user!,
                                                  notification.id ?? "",
                                                ),
                                            child: Text(
                                              "Accept".tr,
                                              style: const TextStyle(
                                                  color: Colors.blue),
                                            ))
                                        : TextButton(
                                            onPressed: () =>
                                                controller.deleteNotification(
                                                    notification.id ?? ""),
                                            child: Text(
                                              "Delete".tr,
                                              style: const TextStyle(
                                                color: Colors.red,
                                              ),
                                            )),
                                    notification.topic == "connection"
                                        ? TextButton(
                                            onPressed: () =>
                                                controller.deleteNotification(
                                                    notification.id ?? ""),
                                            child: Text(
                                              "Decline".tr,
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                                const Divider(
                                  thickness: 1.4,
                                )
                              ],
                            ),
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(notification.user!.profile!),
                            ),
                            trailing: Text(
                                dateTimeManager.getTime(notification.date!)),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
