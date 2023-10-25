import 'package:disan/Controller/timeline_tap_controller.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Model/comment_model.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CommentsPage extends StatelessWidget {
  CommentsPage({super.key});
  final userController = Get.find<UserController>();
  final controller = Get.put(TimelineTapController());
  final DanModel dan = Get.arguments['dan'];
  final time = DateFormat('hh:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Set this property to true
      appBar: AppBar(
        title: const Text("Dan comments"),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          StreamBuilder(
            stream: controller.getPost(dan.id!),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              DanModel dan = DanModel.fromJson(snapshot.data!.data()!);
              List<Comment> comments = dan.comments!;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
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
                        trailing:
                            Text(time.format(comments[index].date!.toDate())),
                        subtitle: Text(
                          comments[index].comment.toString(),
                          maxLines: 3,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.black54),
                        ),
                      ),
                    );
                  },
                  childCount: comments.length,
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: ListTile(
        title: TextFormField(
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
          onPressed: () {},
          icon: const Icon(
            Icons.mic,
            color: Colors.red,
            size: 40,
          ),
        ),
      ),
    );
  }
}
