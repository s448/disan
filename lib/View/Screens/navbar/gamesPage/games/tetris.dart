import 'package:flutter/material.dart';

class TetrisGame extends StatefulWidget {
  const TetrisGame({super.key});

  @override
  _TetrisGameState createState() => _TetrisGameState();
}

class _TetrisGameState extends State<TetrisGame> {
  @override
  void initState() {
    super.initState();

    double screenHeight = MediaQuery.of(context).size.height;
    rows = (screenHeight / 30).floor();

    grid = List.generate(rows, (i) => List.generate(cols, (j) => 0));

    spawnTetromino();
  }

  int rows = 20;
  int cols = 10;
  List<List<int>> grid = List.generate(20, (i) => List.generate(10, (j) => 0));
  int currentTetromino = 0;
  int tetrominoX = 0;
  int tetrominoY = 0;

  List<List<List<int>>> tetrominos = [
    [
      [1, 1, 1, 1], // I-Piece
    ],
    [
      [1, 1],
      [1, 1], // O-Piece
    ],
    [
      [1, 1, 1],
      [0, 1, 0], // T-Piece
    ],
    [
      [1, 1, 1],
      [1, 0, 0], // L-Piece
    ],
    [
      [1, 1, 1],
      [0, 0, 1], // J-Piece
    ],
    [
      [1, 1, 0],
      [0, 1, 1], // S-Piece
    ],
    [
      [0, 1, 1],
      [1, 1, 0], // Z-Piece
    ],
  ];

  void spawnTetromino() {
    currentTetromino = 0;
    tetrominoX = cols ~/ 2;
    tetrominoY = 0;
  }

  void rotateTetromino() {
    setState(() {
      final List<List<int>> newTetromino = [];
      for (int y = 0; y < tetrominos[currentTetromino][0].length; y++) {
        newTetromino
            .add(List.generate(tetrominos[currentTetromino].length, (x) => 0));
      }

      for (int y = 0; y < tetrominos[currentTetromino].length; y++) {
        for (int x = 0; x < tetrominos[currentTetromino][y].length; x++) {
          newTetromino[x][y] = tetrominos[currentTetromino][y][x];
        }
      }

      if (tetrominoX + newTetromino.length <= cols &&
          tetrominoY + newTetromino[0].length <= rows) {
        tetrominos[currentTetromino] = newTetromino;
      }
    });
  }

  void moveTetromino(int dx, int dy) {
    setState(() {
      if (tetrominoX + dx >= 0 &&
          tetrominoX + dx + tetrominos[currentTetromino][0].length <= cols &&
          tetrominoY + dy >= 0 &&
          tetrominoY + dy + tetrominos[currentTetromino].length <= rows) {
        tetrominoX += dx;
        tetrominoY += dy;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Tetris'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
              ),
              itemBuilder: (BuildContext context, int index) {
                int row = index ~/ cols;
                int col = index % cols;
                Color color = Colors.white;
                if (grid[row][col] == 1) {
                  color = Colors.blue;
                } else if (row >= tetrominoY &&
                    row < tetrominoY + tetrominos[currentTetromino].length &&
                    col >= tetrominoX &&
                    col < tetrominoX + tetrominos[currentTetromino][0].length &&
                    tetrominos[currentTetromino][row - tetrominoY]
                            [col - tetrominoX] ==
                        1) {
                  color = Colors.blue;
                }
                return Container(
                  margin: EdgeInsets.all(1),
                  color: color,
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.rotate_right),
                onPressed: rotateTetromino,
              ),
              IconButton(
                icon: Icon(Icons.arrow_left),
                onPressed: () => moveTetromino(-1, 0),
              ),
              IconButton(
                icon: Icon(Icons.arrow_right),
                onPressed: () => moveTetromino(1, 0),
              ),
              IconButton(
                icon: Icon(Icons.arrow_downward),
                onPressed: () => moveTetromino(0, 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
