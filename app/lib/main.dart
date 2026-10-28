import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

const Color navy = Color(0xFF1C1C1C);
const Color purple = Color(0xFF5757FF);
const Color green = Color(0xFF187A38);

void main() {
  runApp(const GuessingApp());
}

class GuessingApp extends StatelessWidget {
  const GuessingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number Guessing Game',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: navy,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// --------------------------------------------------
// SCREEN 1: SPLASH SCREEN
// --------------------------------------------------

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),

            Image.asset(
              'assets/guess.png',
              width: 235,
              height: 192,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(
                width: 235,
                height: 192,
                child: Icon(
                  Icons.sports_esports,
                  color: purple,
                  size: 120,
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Guses',
                    style: TextStyle(
                      color: purple,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Number',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.fromLTRB(47, 0, 42, 80),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LevelScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: const Text(
                    'Start To Play',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------
// SCREEN 2: LEVEL SELECTION
// --------------------------------------------------

class LevelScreen extends StatelessWidget {
  const LevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 48),

            Image.asset(
              'assets/logo.png',
              width: 172,
              height: 188,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox(
                width: 172,
                height: 188,
                child: Icon(
                  Icons.all_inclusive,
                  color: Color(0xFFFFCA42),
                  size: 150,
                ),
              ),
            ),

            const Spacer(),

            levelButton(
              context,
              image: 'assets/green.png',
              title: 'Level 1',
              subtitle: 'Easy',
              maxNumber: 9,
            ),

            const SizedBox(height: 40),

            levelButton(
              context,
              image: 'assets/blue.png',
              title: 'Level 2',
              subtitle: 'Medium',
              maxNumber: 50,
            ),

            const SizedBox(height: 37),

            levelButton(
              context,
              image: 'assets/red.png',
              title: 'Level 3',
              subtitle: 'Hard',
              maxNumber: 100,
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget levelButton(
    BuildContext context, {
    required String image,
    required String title,
    required String subtitle,
    required int maxNumber,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SizedBox(
        width: double.infinity,
        height: 71,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GameScreen(
                  level: title,
                  maxNumber: maxNumber,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: purple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
          ),
          child: Row(
            children: [
              Image.asset(
                image,
                width: 48,
                height: 40,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.diamond,
                  color: Colors.white,
                  size: 38,
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 24,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// SCREEN 3: GUESSING GAME
// --------------------------------------------------

class GameScreen extends StatefulWidget {
  final String level;
  final int maxNumber;

  const GameScreen({
    super.key,
    required this.level,
    required this.maxNumber,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int secretNumber;
  String enteredNumber = '';
  int score = 240;
  String message = '';
  bool gameWon = false;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    secretNumber = Random().nextInt(widget.maxNumber) + 1;
    enteredNumber = '';
    message = '';
    gameWon = false;
  }

  void pressNumber(String number) {
    if (gameWon) return;

    setState(() {
      if (enteredNumber.length < widget.maxNumber.toString().length) {
        enteredNumber += number;
      }
      message = '';
    });
  }

  void clearNumber() {
    setState(() {
      enteredNumber = '';
      message = '';
    });
  }

  void checkNumber() {
    if (enteredNumber.isEmpty) {
      setState(() => message = 'Please enter a number!');
      return;
    }

    final guess = int.tryParse(enteredNumber);

    if (guess == null || guess < 1 || guess > widget.maxNumber) {
      setState(() {
        message = 'Enter 1 to ${widget.maxNumber}';
      });
      return;
    }

    setState(() {
      if (guess == secretNumber) {
        message = 'Correct Number!';
        score += 10;
        gameWon = true;
      } else {
        score = max(0, score - 10);

        message = guess < secretNumber
            ? 'Try a Higher Number!'
            : 'Try a Lower Number!';
      }
    });

    if (gameWon) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;

        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: navy,
            title: const Text(
              'Congratulations!',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'You guessed the number correctly!\nScore: $score',
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  setState(startNewGame);
                },
                child: const Text('Play Again'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  Navigator.pop(context);
                },
                child: const Text('Levels'),
              ),
            ],
          ),
        );
      });
    }
  }

  Widget numberButton(
    String text, {
    VoidCallback? onTap,
    bool special = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: special ? green : Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          side: const BorderSide(
            color: Color(0xFF00FF00),
            width: 0.8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                Expanded(
                  child: Text(
                    'between 1 & ${widget.maxNumber}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 45),
              ],
            ),

            const SizedBox(height: 72),

            Container(
              width: 185,
              height: 180,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF08712A),
                    Color(0xFF509878),
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                enteredNumber.isEmpty ? '5' : enteredNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: numberButton(
                          '1',
                          onTap: () => pressNumber('1'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: numberButton(
                          '2',
                          onTap: () => pressNumber('2'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: numberButton(
                          '3',
                          onTap: () => pressNumber('3'),
                        ),
                      ),
                      const SizedBox(width: 17),
                      Expanded(
                        child: numberButton(
                          'C',
                          onTap: clearNumber,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 19),

                  Row(
                    children: [
                      Expanded(
                        child: numberButton(
                          '4',
                          onTap: () => pressNumber('4'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: numberButton(
                          '5',
                          onTap: () => pressNumber('5'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: numberButton(
                          '6',
                          onTap: () => pressNumber('6'),
                        ),
                      ),
                      const SizedBox(width: 17),
                      Expanded(
                        child: numberButton(
                          'Score',
                          special: true,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Your score: $score'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 19),

                  Row(
                    children: [
                      Expanded(
                        child: numberButton(
                          '7',
                          onTap: () => pressNumber('7'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: numberButton(
                          '8',
                          onTap: () => pressNumber('8'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: numberButton(
                          '9',
                          onTap: () => pressNumber('9'),
                        ),
                      ),
                      const SizedBox(width: 17),
                      Expanded(
                        child: numberButton(
                          '$score',
                          special: true,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 19),

                  Row(
                    children: [
                      Expanded(
                        child: numberButton(
                          '0',
                          onTap: () => pressNumber('0'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 3,
                        child: numberButton(
                          'Check',
                          onTap: checkNumber,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    height: 28,
                    child: FittedBox(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}
