import 'package:flutter/material.dart';
import 'dart:math';

class MemoryMatchingGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Matching Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MemoryMatchingGameScreen(),
    );
  }
}

class MemoryMatchingGameScreen extends StatefulWidget {
  @override
  _MemoryMatchingGameScreenState createState() =>
      _MemoryMatchingGameScreenState();
}

class _MemoryMatchingGameScreenState extends State<MemoryMatchingGameScreen> {
  final List<String> _icons = [
    "🍎",
    "🍌",
    "🍉",
    "🍇",
    "🍓",
    "🍒",
    "🥑",
    "🥥",
  ];

  late List<String> _cards;
  late List<bool> _cardFlips;
  int? _firstCardIndex;
  int? _secondCardIndex;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _cards = [..._icons, ..._icons]..shuffle();
    _cardFlips = List<bool>.filled(_cards.length, false);
    _firstCardIndex = null;
    _secondCardIndex = null;
  }

  void _onCardTap(int index) {
    setState(() {
      if (_firstCardIndex == null) {
        _firstCardIndex = index;
      } else if (_secondCardIndex == null && _firstCardIndex != index) {
        _secondCardIndex = index;
        if (_cards[_firstCardIndex!] != _cards[_secondCardIndex!]) {
          // If cards don't match, flip them back after a delay
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _cardFlips[_firstCardIndex!] = false;
              _cardFlips[_secondCardIndex!] = false;
              _firstCardIndex = null;
              _secondCardIndex = null;
            });
          });
        } else {
          // If cards match, keep them flipped
          _firstCardIndex = null;
          _secondCardIndex = null;
        }
      }
      _cardFlips[index] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          color: Colors.grey, // Set background color to grey
        ),
        title: Text(
          'Memory Matching Game',
          style: TextStyle(
            color: Colors.orange, // Set text color to orange
          ),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (!_cardFlips[index]) {
                _onCardTap(index);
              }
            },
            child: Card(
              color: _cardFlips[index] ? Colors.white : Colors.grey,
              child: Center(
                child: Text(
                  _cardFlips[index] ? _cards[index] : '',
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _initializeGame();
          });
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}

