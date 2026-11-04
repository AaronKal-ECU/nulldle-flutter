import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/game_viewmodel.dart';
import 'game_screen.dart';
import 'services/stats_screen.dart'; // import the new stats screen
import 'constants.dart'; // import constants
// Aaron Mark Kalaji, CSP2108, 1/11/25

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameViewModel(),
      child: const WordleApp(),
    ),
  );
}

// entry point that configures app-wide settings and decides the initial screen.
class WordleApp extends StatelessWidget {
  const WordleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

// landing screen showing the title, game blurb, and a button to start the game.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // simple text widget for the blurb, using the common style.
  Widget _buildBlurbText(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: kNulldleTextStyle.copyWith(fontSize: 14.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // changed from spaceBetween to spaceAround for better vertical spacing
        children: [
          // title
          Text(
            'Nulldle',
            style: kNulldleTextStyle.copyWith(fontSize: 48.0),
          ),

          // photo
          Image.asset(
            'assets/title.png',
            width: 200,
          ),

          // rules paragraph
          _buildBlurbText(
            'Guess the hidden five-letter word in just six tries! After each guess, tiles will light up, green means the letter is in the right spot, yellow means the letter is in the word but in the wrong spot, and grey means the letter is not in the word at all.',
          ),

          // play
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GameScreen()),
              );
            },
            child: Text(
              'Play Game',
              style: kNulldleTextStyle.copyWith(
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
          ),
          // stats
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatsScreen()),
              );
            },
            child: Text(
              'Stats',
              style: kNulldleTextStyle.copyWith(
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
