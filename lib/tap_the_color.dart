import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class TapTheColorGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tap the Color Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TapTheColorGameScreen(),
    );
  }
}

class TapTheColorGameScreen extends StatefulWidget {
  @override
  _TapTheColorGameScreenState createState() => _TapTheColorGameScreenState();
}

class _TapTheColorGameScreenState extends State<TapTheColorGameScreen> {
  Random _random = Random();
  List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple
  ];
  List<String> _colorNames = ["Red", "Green", "Blue", "Yellow", "Orange", "Purple"];
  Color _currentColor = Colors.transparent;
  String _currentColorName = '';
  int _score = 0;
  Timer? _timer;
  bool _gameStarted = false;

  @override
  void initState() {
    super.initState();
  }

  void startGame() {
    setState(() {
      _gameStarted = true;
      _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        updateColor();
      });
    });
  }

  void updateColor() {
    setState(() {
      int colorIndex = _random.nextInt(_colors.length);
      _currentColor = _colors[colorIndex];
      _currentColorName = _colorNames[_random.nextInt(_colorNames.length)];
    });
  }

  void checkColorMatch(bool tappedCorrectly) {
    if (_gameStarted && tappedCorrectly && _currentColor == _colors[_colorNames.indexOf(_currentColorName)]) {
      setState(() {
        _score++;
      });
    } else {
      // Handle incorrect tap
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool _buttonClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            color: Colors.grey, // Set background color to grey
          ),
          title: Text(
            'Tap the Color Game ',
            style: TextStyle(
              color: Colors.orange, // Set text color to orange
            ),
          ),
        ),

      body: Center(
        child: _gameStarted
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tap the color:',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            Text(
              _currentColorName,
              style: TextStyle(fontSize: 24.0, color: _currentColor),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => checkColorMatch(true),
              style: ElevatedButton.styleFrom(
                primary: _currentColor,
              ),
              child: Text(
                'Tap Here',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Score: $_score',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        )
            : ElevatedButton(
          onPressed: startGame,
          style: ElevatedButton.styleFrom(
            primary: _buttonClicked ? Colors.grey : Colors.orange, // Change button color based on buttonClicked
          ),
          child: Text('Start Game'),
        ),
      ),
    );
  }
}