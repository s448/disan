import 'package:disan/Controller/timeline_tap_controller.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentsPage extends StatelessWidget {
  CommentsPage({super.key});
  final userController = Get.find<UserController>();
  final controller = Get.put(TimelineTapController());
  final DanModel dan = Get.arguments['dan'];
  @override
  Widget build(BuildContext context) {
    final currentUserModel = userController.curentUserModel;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Dan comments".tr),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            ListView.builder(
              itemCount: dan.comments!.length,
              shrinkWrap: true,
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
                    dan.comments![index].user!.name.toString(),
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    dan.comments![index].comment.toString(),
                    maxLines: 3,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.black54),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ListTile(
        leading: CircleAvatar(
          radius: 22.0,
          backgroundColor: Colors.blue,
          backgroundImage: NetworkImage(
            currentUserModel.profile.toString(),
          ),
        ),
        title: TextFormField(
          onChanged: (value) {
            controller.comment.value = value;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            fillColor: const Color.fromARGB(255, 194, 192, 192),
            filled: true,
            // border: InputBorder.none,
            hintText: "Add comment ..",
          ),
        ),
        trailing: IconButton(
          onPressed: () => controller.addCommentToPost(
            dan.id!,
          ),
          icon: const Icon(
            Icons.send,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
