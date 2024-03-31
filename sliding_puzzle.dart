import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(SlidingPuzzle());
}

class SlidingPuzzle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sliding Puzzle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SlidingPuzzleScreen(),
    );
  }
}

class SlidingPuzzleScreen extends StatefulWidget {
  @override
  _SlidingPuzzleScreenState createState() => _SlidingPuzzleScreenState();
}

class _SlidingPuzzleScreenState extends State<SlidingPuzzleScreen> {
  late List<int> _tiles;
  final int _gridSize = 4; // 4x4 grid
  late Random _random;

  @override
  void initState() {
    super.initState();
    _random = Random();
    _initializeTiles();
  }

  void _initializeTiles() {
    _tiles = List.generate(_gridSize * _gridSize, (index) => index);
    _tiles.shuffle(_random);
  }

  void _handleTileTap(int index) {
    setState(() {
      if (_isValidMove(index)) {
        _swapTiles(index);
        if (_isGameComplete()) {
          _showGameCompleteDialog();
        }
      }
    });
  }

  bool _isValidMove(int index) {
    final int emptyTileIndex = _tiles.indexOf(0);
    final int rowDiff = (emptyTileIndex ~/ _gridSize) - (index ~/ _gridSize);
    final int colDiff = (emptyTileIndex % _gridSize) - (index % _gridSize);
    return (rowDiff.abs() == 1 && colDiff == 0) || (colDiff.abs() == 1 && rowDiff == 0);
  }

  void _swapTiles(int index) {
    final int emptyTileIndex = _tiles.indexOf(0);
    final int temp = _tiles[emptyTileIndex];
    _tiles[emptyTileIndex] = _tiles[index];
    _tiles[index] = temp;
  }

  bool _isGameComplete() {
    for (int i = 0; i < _tiles.length - 1; i++) {
      if (_tiles[i] != i + 1) {
        return false;
      }
    }
    return true;
  }

  void _showGameCompleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You solved the puzzle!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _initializeTiles();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          color: Colors.grey, // Set background color to grey
        ),
        title: Text(
          'Sliding Puzzle Game',
          style: TextStyle(
            color: Colors.orange, // Set text color to orange
          ),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _gridSize,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _tiles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _handleTileTap(index),
            child: Container(
              color: _tiles[index] == 0 ? Colors.orange : Colors.grey,
              child: Center(
                child: Text(
                  _tiles[index] != 0 ? _tiles[index].toString() : '',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

