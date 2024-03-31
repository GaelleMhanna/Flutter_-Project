import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(Game2048());
}

class Game2048 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Game2048Screen(),
    );
  }
}

class Game2048Screen extends StatefulWidget {
  @override
  _Game2048ScreenState createState() => _Game2048ScreenState();
}

class _Game2048ScreenState extends State<Game2048Screen> {
  late List<List<int>> _board;
  final int _boardSize = 4;
  late Random _random;

  @override
  void initState() {
    super.initState();
    _random = Random();
    _initializeBoard();
  }

  void _initializeBoard() {
    _board = List.generate(_boardSize, (i) => List<int>.filled(_boardSize, 0));
    _addNewTile();
    _addNewTile();
  }

  void _addNewTile() {
    List<int> emptyCells = [];
    for (int i = 0; i < _boardSize; i++) {
      for (int j = 0; j < _boardSize; j++) {
        if (_board[i][j] == 0) {
          emptyCells.add(i * _boardSize + j);
        }
      }
    }
    if (emptyCells.isNotEmpty) {
      int randomIndex = emptyCells[_random.nextInt(emptyCells.length)];
      int value = _random.nextInt(10) < 9 ? 2 : 4; // 90% chance of 2, 10% chance of 4
      _board[randomIndex ~/ _boardSize][randomIndex % _boardSize] = value;
    }
    setState(() {}); // Update the UI after adding a new tile
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              color: Colors.grey, // Set background color to grey
            ),
            title: Text(
              '2048 Game',
              style: TextStyle(
                color: Colors.orange, // Set text color to orange
              ),
            ),
          ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.grey[200],
                  child:GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _boardSize,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _boardSize * _boardSize,
                    itemBuilder: (context, index) {
                      int row = index ~/ _boardSize;
                      int col = index % _boardSize;
                      return Container(
                        padding: EdgeInsets.all(4), // Adjust padding here
                        color: _getTileColor(_board[row][col]),
                        child: Center(
                          child: Text(
                            _board[row][col] != 0 ? _board[row][col].toString() : '',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Adjust font size here
                          ),
                        ),
                      );
                    },
                  ),

                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _moveUp,
                    child: Icon(Icons.arrow_upward),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _moveLeft,
                    child: Icon(Icons.arrow_back),
                  ),
                  SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: _moveRight,
                    child: Icon(Icons.arrow_forward),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _moveDown,
                    child: Icon(Icons.arrow_downward),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTileColor(int value) {
    switch (value) {
      case 2:
        return Colors.orange[50]!;
      case 4:
        return Colors.orange[100]!;
      case 8:
        return Colors.orange[200]!;
      case 16:
        return Colors.orange[300]!;
      case 32:
        return Colors.orange[400]!;
      case 64:
        return Colors.orange[500]!;
      case 128:
        return Colors.orange[600]!;
      case 256:
        return Colors.orange[700]!;
      case 512:
        return Colors.orange[800]!;
      case 1024:
        return Colors.orange[900]!;
      case 2048:
        return Colors.red[900]!;
      default:
        return Colors.grey[300]!;
    }
  }

  void _moveLeft() {
    bool moved = false;
    for (int row = 0; row < _boardSize; row++) {
      for (int col = 1; col < _boardSize; col++) {
        if (_board[row][col] != 0) {
          int value = _board[row][col];
          int mergeIndex = col;
          while (mergeIndex > 0 && _board[row][mergeIndex - 1] == 0) {
            mergeIndex--;
          }
          if (mergeIndex > 0 && _board[row][mergeIndex - 1] == value) {
            _board[row][mergeIndex - 1] *= 2;
            _board[row][col] = 0;
            moved = true;
          } else if (mergeIndex != col) {
            _board[row][mergeIndex] = value;
            _board[row][col] = 0;
            moved = true;
          }
        }
      }
    }
    if (moved) _addNewTile();
  }

  void _moveRight() {
    bool moved = false;
    for (int row = 0; row < _boardSize; row++) {
      for (int col = _boardSize - 2; col >= 0; col--) {
        if (_board[row][col] != 0) {
          int value = _board[row][col];
          int mergeIndex = col;
          while (mergeIndex < _boardSize - 1 && _board[row][mergeIndex + 1] == 0) {
            mergeIndex++;
          }
          if (mergeIndex < _boardSize - 1 && _board[row][mergeIndex + 1] == value) {
            _board[row][mergeIndex + 1] *= 2;
            _board[row][col] = 0;
            moved = true;
          } else if (mergeIndex != col) {
            _board[row][mergeIndex] = value;
            _board[row][col] = 0;
            moved = true;
          }
        }
      }
    }
    if (moved) _addNewTile();
  }

  void _moveUp() {
    bool moved = false;
    for (int col = 0; col < _boardSize; col++) {
      for (int row = 1; row < _boardSize; row++) {
        if (_board[row][col] != 0) {
          int value = _board[row][col];
          int mergeIndex = row;
          while (mergeIndex > 0 && _board[mergeIndex - 1][col] == 0) {
            mergeIndex--;
          }
          if (mergeIndex > 0 && _board[mergeIndex - 1][col] == value) {
            _board[mergeIndex - 1][col] *= 2;
            _board[row][col] = 0;
            moved = true;
          } else if (mergeIndex != row) {
            _board[mergeIndex][col] = value;
            _board[row][col] = 0;
            moved = true;
          }
        }
      }
    }
    if (moved) _addNewTile();
  }

  void _moveDown() {
    bool moved = false;
    for (int col = 0; col < _boardSize; col++) {
      for (int row = _boardSize - 2; row >= 0; row--) {
        if (_board[row][col] != 0) {
          int value = _board[row][col];
          int mergeIndex = row;
          while (mergeIndex < _boardSize - 1 && _board[mergeIndex + 1][col] == 0) {
            mergeIndex++;
          }
          if (mergeIndex < _boardSize - 1 && _board[mergeIndex + 1][col] == value) {
            _board[mergeIndex + 1][col] *= 2;
            _board[row][col] = 0;
            moved = true;
          } else if (mergeIndex != row) {
            _board[mergeIndex][col] = value;
            _board[row][col] = 0;
            moved = true;
          }
        }
      }
    }
    if (moved) _addNewTile();
  }
}
