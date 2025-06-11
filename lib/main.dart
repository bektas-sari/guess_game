import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const GuessGameApp());
}

class GuessGameApp extends StatelessWidget {
  const GuessGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess Game',
      home: const GuessGameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GuessGameScreen extends StatefulWidget {
  const GuessGameScreen({super.key});

  @override
  State<GuessGameScreen> createState() => _GuessGameScreenState();
}

class _GuessGameScreenState extends State<GuessGameScreen> {
  bool _showWelcome = true;
  double _welcomeOpacity = 1.0;
  String? _answer; // "red" or "blue"
  String? _resultMessage;
  bool _hasGuessed = false;
  int _score = 0;
  int _round = 0;
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _startWelcomeTimer();
  }

  void _startWelcomeTimer() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _welcomeOpacity = 0.0;
      });
      Future.delayed(const Duration(milliseconds: 400), () {
        setState(() {
          _showWelcome = false;
          _startGame();
        });
      });
    });
  }

  void _startGame() {
    _answer = Random().nextBool() ? "red" : "blue";
    _resultMessage = null;
    _hasGuessed = false;
  }

  void _handleGuess(String guess) {
    if (_hasGuessed || _gameOver) return;

    setState(() {
      _hasGuessed = true;
      _round++;
      if (guess == _answer) {
        _score++;
        _resultMessage = "Correct!";
      } else {
        _resultMessage = "Wrong!";
      }

      if (_round == 10) {
        _gameOver = true;
      } else {
        Timer(const Duration(seconds: 2), () {
          setState(() {
            _startGame();
          });
        });
      }
    });
  }

  void _restartGame() {
    setState(() {
      _score = 0;
      _round = 0;
      _gameOver = false;
      _startGame();
    });
  }

  Color _getCircleColor() {
    if (!_hasGuessed) return Colors.grey;
    return _answer == "red" ? Colors.red : Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: _showWelcome
            ? AnimatedOpacity(
          opacity: _welcomeOpacity,
          duration: const Duration(milliseconds: 400),
          child: const Text(
            "Welcome",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
        )
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Guess the Color",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 20),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: _getCircleColor(),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Guess",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              if (!_gameOver)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _hasGuessed
                          ? null
                          : () => _handleGuess("blue"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                      ),
                      child: const Text(
                        "Blue",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 24),
                    ElevatedButton(
                      onPressed: _hasGuessed
                          ? null
                          : () => _handleGuess("red"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                      ),
                      child: const Text(
                        "Red",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 32),
              AnimatedOpacity(
                opacity: _resultMessage != null ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _resultMessage ?? '',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: _resultMessage == "Correct!"
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              if (_gameOver)
                Column(
                  children: [
                    Text(
                      "Game Over",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Your Score: $_score / 10",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _restartGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                      ),
                      child: const Text(
                        "Play Again",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
