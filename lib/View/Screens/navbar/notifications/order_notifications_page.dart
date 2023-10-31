import 'package:disan/Controller/notifications_page_controller.dart';
import 'package:disan/Core/extension/time_difference.dart';
import 'package:disan/Model/order_model.dart';
import 'package:disan/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class MyOrdersPage extends StatelessWidget {
  MyOrdersPage({super.key});
  final controller = Get.find<NotificationsPageController>();
  final DateTimeManager dateTimeManager = DateTimeManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders".tr),
        centerTitle: true,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.blue,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 18,
            ),
            SizedBox(
              child: StreamBuilder(
                stream: controller.getOrderNotifications(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final orders = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        OrderModel order = orders[index];
                        return InkWell(
                          onTap: () => Get.toNamed(Routes.productDetails,
                              arguments: {'dan': order.dan}),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                    "${order.user!.name!} Requested an order for:"),
                                subtitle: Text(order.dan!.description ?? ''),
                                leading: Image.network(
                                  order.dan!.imgs![0],
                                  fit: BoxFit.cover,
                                ),
                                trailing:
                                    Text(dateTimeManager.getTime(order.date!)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => Get.toNamed(
                                        Routes.profile,
                                        arguments: {"uid": order.user!.id},
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("View profile ".tr),
                                          const Icon(
                                            Ionicons.person_outline,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => {
                                        //TODO handle whatsapp message
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Colors.green,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Contact ".tr,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          const Icon(
                                            Ionicons.logo_whatsapp,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                thickness: 1.4,
                              )
                            ],
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
