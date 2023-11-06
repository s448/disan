import 'package:disan/Model/clip_model.dart';
import 'package:flutter/material.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key, required this.clipModel});
  final ClipModel clipModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 110),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        child:
                            Image.network(clipModel.user!.profile.toString()),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        clipModel.user!.name ?? "user unknown",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 10),
                      const SizedBox(width: 6),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Follow',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 6),
                  Text(clipModel.caption.toString()),
                  const SizedBox(height: 10),
                ],
              ),
              Column(
                children: [
                  const Icon(Icons.favorite_outline),
                  Text(clipModel.likers!.length.toString()),
                  const SizedBox(height: 20),
                  const Icon(Icons.comment_rounded),
                  Text(clipModel.comments!.length.toString()),
                  const SizedBox(height: 20),
                  Transform(
                    transform: Matrix4.rotationZ(5.8),
                    child: const Icon(Icons.send),
                  ),
                  const SizedBox(height: 50),
                  const Icon(Icons.more_vert),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
