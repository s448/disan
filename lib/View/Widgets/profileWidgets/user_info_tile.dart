import 'package:flutter/material.dart';

class UserInfoTile extends StatelessWidget {
  const UserInfoTile(
      {super.key, required this.ic, required this.title, required this.num});
  final Icon ic;
  final String num;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ic,
        const SizedBox(width: 6),
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: num,
              style: const TextStyle(
                fontSize: 19,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: " $title",
              style: const TextStyle(
                fontSize: 19,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ]),
        )
      ],
    );
  }
}
