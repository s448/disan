import 'package:disan/Controller/clip_controller.dart';
import 'package:disan/Controller/timeline_tap_controller.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Core/extension/time_difference.dart';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Model/comment_model.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentsPage extends StatelessWidget {
  CommentsPage({super.key});
  final userController = Get.find<UserController>();
  final controller = Get.put(TimelineTapController());
  final DanModel dan = Get.arguments['dan'];
  final DateTimeManager dateTimeManager = DateTimeManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Dan comments".tr),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.blue,
          ),
        ),
      ),
      body: GetBuilder<ClipController>(builder: (context) {
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: StreamBuilder(
                  stream: controller.getPost(dan.id!),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    DanModel dan = DanModel.fromJson(snapshot.data!.data()!);
                    List<Comment> comments = dan.comments!;
                    return ListView.builder(
                      itemCount: comments.length,
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
                            comments[index].user!.name.toString(),
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: Text(
                              dateTimeManager.getTime(comments[index].date!)),
                          subtitle: Text(
                            comments[index].comment.toString(),
                            maxLines: 3,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.black54),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: controller.commentController,
                onChanged: (value) {
                  controller.comment.value = value;
                },
                onFieldSubmitted: (value) => controller.addCommentToPost(
                  dan.id!,
                ),
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: const Color.fromARGB(255, 194, 192, 192),
                  filled: true,
                  hintText: "Add comment ..",
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  if (controller.commentController.text.isNotEmpty) {
                    controller.addCommentToPost(
                      dan.id!,
                    );
                    controller.commentController.text = '';
                  } else {
                    customSnackbar(
                        "Comment is empty".tr, "please write something".tr);
                  }
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
