import 'package:disan/View/Screens/navbar/gamesPage/games/snake_game.dart';
import 'package:disan/View/Screens/navbar/gamesPage/games/tetris.dart';
import 'package:disan/View/Screens/navbar/gamesPage/games/tik_tak_toe.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GamesPage extends StatelessWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GridView.count(
        padding: const EdgeInsets.all(8),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: [
          InkWell(
            onTap: () => Get.to(const SnakeGame()),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(8)),
              width: Get.width * 0.4,
              height: Get.height * 0.3,
              child: Text("Snake".tr),
            ),
          ),
          InkWell(
            onTap: () => Get.to(TikTakToe()),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              width: Get.width * 0.4,
              height: Get.height * 0.3,
              child: Text("Tik Tak Toe".tr),
            ),
          ),
          InkWell(
            onTap: () => Get.to(const TetrisGame()),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              width: Get.width * 0.4,
              height: Get.height * 0.3,
              child: Text("Tetris".tr),
            ),
          ),
        ],
      ),
    );
  }
}
