import 'package:flutter/material.dart';
import 'package:flutter_project/memory_matching.dart';
import 'package:flutter_project/snake.dart';
import 'package:flutter_project/tap_the_color.dart';
import 'hangman.dart';
import '2048.dart'; // Importing the 2048 game file
import 'dart:html' as html; // Import dart:html
import 'sliding_puzzle.dart';
import 'tic_tac_toe.dart';

void main() {
  runApp(MultiGameApp());
}

class MultiGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      theme: ThemeData(
        primarySwatch: Colors.orange,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey, // Set background color of app bar to grey
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.orange, // Set text color to orange
          ),
        ),
      ),
    );
  }
}


class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi-Game App'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SnakeGame()),
                  );
                },
                child: GameOption(
                  title: 'Snake',
                  icon: Icons.directions_run,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TapTheColorGame()),
                  );
                },
                child: GameOption(
                  title: 'Tap the Color',
                  icon: Icons.color_lens,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HangmanScreen()),
                  );
                },
                child: GameOption(
                  title: 'Hangman',
                  icon: Icons.text_format,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Game2048Screen()), // Navigate to 2048 game
                  );
                },
                child: GameOption(
                  title: '2048',
                  icon: Icons.gamepad,
                  color: Colors.purple, // Choose a color for 2048 game
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MemoryMatchingGameScreen()), // Navigate to Memory Matching game
                  );
                },
                child: GameOption(
                  title: 'Memory Matching',
                  icon: Icons.memory,
                  color: Colors.red, // Choose a color for Memory Matching game
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SlidingPuzzleScreen()), // Navigate to Sliding Puzzle game
                  );
                },
                child: GameOption(
                  title: 'Sliding Puzzle',
                  icon: Icons.blur_on,
                  color: Colors.teal, // Choose a color for Sliding Puzzle game
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TicTacToeScreen()), // Navigate to Tic Tac Toe game
                  );
                },
                child: GameOption(
                  title: 'Tic Tac Toe',
                  icon: Icons.close,
                  color: Colors.deepOrange, // Choose a color for Tic Tac Toe game
                ),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  const url = 'https://store.steampowered.com/app/872990/Stream_Games/';
                  html.window.open(url, 'more_games'); // Open URL in browser
                },
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
                child: Text('More Games'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameOption extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;

  const GameOption({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  _GameOptionState createState() => _GameOptionState();
}

class _GameOptionState extends State<GameOption> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return Hover(
      onHover: (value) {
        setState(() {
          _hovering = value;
        });
      },
      child: Container(
        width: _hovering ? 220 : 200, // Increase width when hovered
        decoration: BoxDecoration(
          color: _hovering ? Colors.grey : widget.color, // Gray background when hovered
          borderRadius: BorderRadius.circular(20), // Curved border
          boxShadow: _hovering
              ? [
            BoxShadow(
              color: Colors.white.withOpacity(0.5), // Fluorescent color around the corners
              spreadRadius: 10,
              blurRadius: 20,
              offset: Offset(0, 0),
            ),
          ]
              : [],
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Icon(
              widget.icon,
              size: _hovering ? 120 : 100, // Increase icon size when hovered
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Hover extends StatefulWidget {
  final Widget child;
  final Function(bool) onHover;

  const Hover({
    required this.child,
    required this.onHover,
  });

  @override
  _HoverState createState() => _HoverState();
}

class _HoverState extends State<Hover> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        widget.onHover(true);
      },
      onExit: (event) {
        widget.onHover(false);
      },
      child: widget.child,
    );
  }
}
