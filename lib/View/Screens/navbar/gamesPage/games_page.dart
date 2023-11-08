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
      appBar: AppBar(
        centerTitle: true,
        title: Text("Games".tr),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(8),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: [
          GameTile(
            gamePage: const SnakeGame(),
            text: "Snake".tr,
            img: "snake",
          ),
          GameTile(
            gamePage: TikTakToe(),
            text: "Tik Tak Toe".tr,
            img: "tik",
          ),
          GameTile(
            gamePage: const TetrisGame(),
            text: "Tetris".tr,
            img: "tetris",
          ),
          // InkWell(
          //   onTap: () => Get.to(TikTakToe()),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: Colors.red,
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     width: Get.width * 0.4,
          //     height: Get.height * 0.3,
          //     child: Text("Tik Tak Toe".tr),
          //   ),
          // ),
          // InkWell(
          //   onTap: () => Get.to(const TetrisGame()),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: Colors.red,
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     width: Get.width * 0.4,
          //     height: Get.height * 0.3,
          //     child: Text("Tetris".tr),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class GameTile extends StatelessWidget {
  const GameTile({
    super.key,
    required this.gamePage,
    required this.text,
    required this.img,
  });
  final Widget gamePage;
  final String text;
  final String img;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(gamePage),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(8)),
        width: Get.width * 0.4,
        height: Get.height * 0.3,
        child: GridTile(
          footer: Container(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          child: Image.asset('assets/games/$img.jpg', fit: BoxFit.fill),
        ),
      ),
    );
  }
}
