import 'package:disan/Controller/clip_controller.dart';
import 'package:disan/Core/extension/time_difference.dart';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Model/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentsPageBody extends StatelessWidget {
  CommentsPageBody(
      {super.key,
      required this.controller,
      required this.comments,
      required this.clipId});
  final ClipController controller;
  final List<Comment> comments;
  final String clipId;
  final DateTimeManager dateTimeManager = DateTimeManager();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.blue,
                      backgroundImage: NetworkImage(
                        comments[index].user!.profile.toString(),
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
                    trailing:
                        Text(dateTimeManager.getTime(comments[index].date!)),
                    subtitle: Text(
                      comments[index].comment.toString(),
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: TextFormField(
              controller: controller.commentController,
              onChanged: (value) {
                controller.comment.value = value;
              },
              onFieldSubmitted: (value) {
                controller.addComment(clipId);
                Get.back();
              },
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
                  controller.addComment(clipId);
                  controller.commentController.text = '';
                } else {
                  customSnackbar(
                      "Comment is empty".tr, "please write something".tr);
                }
                Get.back();
              },
              icon: const Icon(
                Icons.send,
                color: Colors.blue,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
