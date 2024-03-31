import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SnakeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SnakeGamePage(),
      ),
    );
  }
}

class SnakeGamePage extends StatefulWidget {
  @override
  _SnakeGamePageState createState() => _SnakeGamePageState();
}

class _SnakeGamePageState extends State<SnakeGamePage> {
  static const int tileSize = 15; // Adjusted tileSize
  static const int gridSize = 15; // Adjusted gridSize
  static const int snakeInitialSize = 3;

  List<Position> snake = [];
  Position food = Position(0, 0);
  Direction direction = Direction.right;
  bool gameOver = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    setState(() {
      snake.clear();
      snake.add(Position(gridSize ~/ 2, gridSize ~/ 2));
      for (int i = 1; i < snakeInitialSize; i++) {
        snake.add(Position(gridSize ~/ 2 - i, gridSize ~/ 2));
      }
      generateFood();
      gameOver = false;
    });
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (gameOver) {
        timer.cancel();
      } else {
        moveSnake();
      }
    });
  }

  void generateFood() {
    final Random random = Random();
    int x = random.nextInt(gridSize);
    int y = random.nextInt(gridSize);
    setState(() {
      food = Position(x, y);
    });
  }

  void moveSnake() {
    Position head = snake.first;
    Position newHead;
    switch (direction) {
      case Direction.up:
        newHead = Position(head.x, (head.y - 1 + gridSize) % gridSize);
        break;
      case Direction.down:
        newHead = Position(head.x, (head.y + 1) % gridSize);
        break;
      case Direction.left:
        newHead = Position((head.x - 1 + gridSize) % gridSize, head.y);
        break;
      case Direction.right:
        newHead = Position((head.x + 1) % gridSize, head.y);
        break;
    }
    if (snake.contains(newHead) || newHead == food) {
      if (newHead == food) {
        setState(() {
          score++;
          // Increase snake's length
          snake.insert(0, newHead);
          generateFood();
        });
      } else {
        gameOver = true;
        return;
      }
    } else {
      setState(() {
        snake.insert(0, newHead);
        if (snake.length > snakeInitialSize) {
          snake.removeLast();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (direction != Direction.up && details.delta.dy > 0) {
          direction = Direction.down;
        } else if (direction != Direction.down && details.delta.dy < 0) {
          direction = Direction.up;
        }
      },
      onHorizontalDragUpdate: (details) {
        if (direction != Direction.left && details.delta.dx > 0) {
          direction = Direction.right;
        } else if (direction != Direction.right && details.delta.dx < 0) {
          direction = Direction.left;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              color: Colors.grey, // Set background color to grey
            ),
            title: Text(
              'Snake Game',
              style: TextStyle(
                color: Colors.orange, // Set text color to orange
              ),
            ),
          ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Score: $score',
                  style: TextStyle(fontSize: 24, color: Colors.orange),
                ),
                SizedBox(height: 20),
                AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    color: Colors.grey[800],
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridSize,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        int x = index % gridSize;
                        int y = index ~/ gridSize;
                        Position position = Position(x, y);
                        if (snake.contains(position)) {
                          return Container(
                            padding: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                color: Colors.orange,
                              ),
                            ),
                          );
                        } else if (food == position) {
                          return Container(
                            padding: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                color: Colors.orange[900],
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            padding: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum Direction { up, down, left, right }

class Position {
  final int x;
  final int y;

  const Position(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Position && runtimeType == other.runtimeType && x == other.x && y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}