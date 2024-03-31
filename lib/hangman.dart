import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(HangmanGame());
}

class HangmanGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HangmanScreen(),
    );
  }
}

class HangmanScreen extends StatefulWidget {
  @override
  _HangmanScreenState createState() => _HangmanScreenState();
}

class _HangmanScreenState extends State<HangmanScreen> {
  final List<String> words = ['FLUTTER', 'DART', 'ANDROID', 'STUDIO'];
  String selectedWord = '';
  String displayedWord = '';
  int lives = 6;
  List<String> guessedLetters = [];

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    selectedWord = words[Random().nextInt(words.length)];
    displayedWord = '_ ' * selectedWord.length;
    lives = 6;
    guessedLetters.clear();
  }

  void _guessLetter(String letter) {
    setState(() {
      if (!selectedWord.contains(letter)) {
        lives--;
      }
      guessedLetters.add(letter);
      displayedWord = '';
      for (int i = 0; i < selectedWord.length; i++) {
        if (guessedLetters.contains(selectedWord[i])) {
          displayedWord += selectedWord[i] + ' ';
        } else {
          displayedWord += '_ ';
        }
      }
      if (!displayedWord.contains('_')) {
        _showDialog(
            'Congratulations!', 'You won! Would you like to play again?');
      }
      if (lives == 0) {
        _showDialog('Game Over',
            'The word was "$selectedWord". Would you like to play again?');
      }
    });
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                _initializeGame();
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
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
          'Hangman Game',
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
                '$displayedWord', // Corrected here
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 20),
              Text(
                'Lives: $lives',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                'Wrong Guesses: ${guessedLetters.where((letter) => !selectedWord.contains(letter)).join(', ')}', // Displaying wrong guesses
                style: TextStyle(fontSize: 20, color: Colors.red[900]),
              ),
              SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                children: List.generate(26, (index) {
                  String letter = String.fromCharCode(index + 65);
                  bool isDisabled = guessedLetters.contains(letter) && !selectedWord.contains(letter);
                  return InkWell(
                    onTap: isDisabled ? null : () {
                      _guessLetter(letter);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5),
                        color: isDisabled ? Colors.grey : Colors.transparent,
                      ),
                      child: Text(
                        letter,
                        style: TextStyle(fontSize: 20, color: isDisabled ? Colors.grey : Colors.black),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
