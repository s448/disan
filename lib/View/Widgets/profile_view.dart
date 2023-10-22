import 'package:chips_choice/chips_choice.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePageTemp extends StatelessWidget {
  ProfilePageTemp({
    Key? key,
    required this.userId,
  }) : super(key: key);
  final controller = Get.find<UserController>();
  final String userId;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.getUserModel(userId),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final userData = UserModel.fromJson(snapshot.data.data());
        return Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          constraints: const BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
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
                          userData.background ?? "",
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
                          userData.profile ?? "",
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
                userData.name ?? "Unknown",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              userData.bio == ""
                  ? const SizedBox(
                      height: 5,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        userData.bio.toString(),
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ),
              userData.type == "MERCHANT"
                  ? Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        for (var c in userData.categories!)
                          Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              c.toString().tr,
                              textAlign: TextAlign.start,
                            ),
                          ),
                      ],
                    )
                  : const SizedBox(),
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
        );
      },
    );
  }
}
