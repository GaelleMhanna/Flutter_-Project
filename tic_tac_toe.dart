import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToe());
}

class TicTacToe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<String> _board = List.filled(9, '');

  bool _isPlayer1Turn = true;
  bool _gameOver = false;
  String _winner = '';
  List<int>? _winningIndices;

  void _checkWinner() {
    // Check rows
    for (int i = 0; i < 9; i += 3) {
      if (_board[i].isNotEmpty &&
          _board[i] == _board[i + 1] &&
          _board[i] == _board[i + 2]) {
        _gameOver = true;
        _winner = _board[i];
        _winningIndices = [i, i + 1, i + 2];
        return;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (_board[i].isNotEmpty &&
          _board[i] == _board[i + 3] &&
          _board[i] == _board[i + 6]) {
        _gameOver = true;
        _winner = _board[i];
        _winningIndices = [i, i + 3, i + 6];
        return;
      }
    }

    // Check diagonals
    if (_board[0].isNotEmpty &&
        _board[0] == _board[4] &&
        _board[0] == _board[8]) {
      _gameOver = true;
      _winner = _board[0];
      _winningIndices = [0, 4, 8];
      return;
    }
    if (_board[2].isNotEmpty &&
        _board[2] == _board[4] &&
        _board[2] == _board[6]) {
      _gameOver = true;
      _winner = _board[2];
      _winningIndices = [2, 4, 6];
      return;
    }

    // Check for draw
    if (!_board.contains('')) {
      _gameOver = true;
      _winner = 'Draw';
    }
  }

  void _resetGame() {
    setState(() {
      _board = List.filled(9, '');
      _isPlayer1Turn = true;
      _gameOver = false;
      _winner = '';
      _winningIndices = null;
    });
  }

  void _handleTap(int index) {
    if (!_gameOver && _board[index].isEmpty) {
      setState(() {
        _board[index] = _isPlayer1Turn ? 'X' : 'O';
        _isPlayer1Turn = !_isPlayer1Turn;
        _checkWinner();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          color: Colors.grey, // Set background color to grey
        ),
        title: Text(
          'Tic Tac Toe Game',
          style: TextStyle(
            color: Colors.orange, // Set text color to orange
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                bool isWinner = _winningIndices != null &&
                    _winningIndices!.contains(index);
                return GestureDetector(
                  onTap: () => _handleTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color: isWinner ? Colors.grey : null,
                    ),
                    child: Center(
                      child: Text(
                        _board[index],
                        style: TextStyle(
                          fontSize: 48,
                          color: isWinner ? Colors.orange : null,
                          fontWeight: isWinner ? FontWeight.bold : null,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 5),
            if (_gameOver)
              Text(
                _winner != 'Draw' ? 'Winner: $_winner' : 'It\'s a Draw!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: _resetGame,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.pressed)) {
                    // Color when button is pressed
                    return Colors.grey;
                  }
                  // Default color
                  return Colors.orange;
                }),
              ),
              child: Text('Reset Game'),
            ),

          ],
        ),
      ),
    );
  }
}

