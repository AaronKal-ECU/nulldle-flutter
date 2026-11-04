// lib/game_screen.dart
// Aaron Mark Kalaji, CSP2108, 1/11/25

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'constants.dart';
import 'game_grid.dart';
import 'keyboard.dart';
import 'viewmodel/game_viewmodel.dart';
import 'model/game_state.dart';

/// main screen of the app
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Timer _timer;
  final TextEditingController _controller = TextEditingController();

  bool _dialogShown = false; // <— NEW flag to prevent multiple dialogs

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _submitGuess(BuildContext context, GameViewModel viewModel) {
    final guess = _controller.text;
    _controller.clear();

    final error = viewModel.submitGuess(guess);

    if (error != null) {
      _showSnackBar(context, error);
    }
  }

  void _showGameDialog(BuildContext context, GameViewModel viewModel) {
    if (_dialogShown) return; // <-- Prevent re-entry
    _dialogShown = true;

    final isWin = viewModel.gameState == GameState.won;
    final String title = isWin ? "You Win!" : "Game Over";
    final Color color = isWin ? kGreen : kBlack;
    final String emoji = isWin ? ":D" : ":(";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji,
                  style: TextStyle(
                      fontSize: 64, color: color, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(title,
                  textAlign: TextAlign.center,
                  style: kNulldleTextStyle.copyWith(fontSize: 20)),
              const SizedBox(height: 8),
              Text(
                "The word was: ${viewModel.targetWord.toUpperCase()}",
                textAlign: TextAlign.center,
                style: kNulldleTextStyle.copyWith(
                    fontSize: 20, color: Colors.black),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                viewModel.resetGame();
                _dialogShown = false; // reset flag for next round
                _showSnackBar(context,
                    isWin ? "You win!" : "Word was: ${viewModel.targetWord}");
              },
              child: Text("New Game",
                  style: kNulldleTextStyle.copyWith(fontSize: 24)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        final timeString =
            viewModel.statsService.formatTime(viewModel.timeElapsed);

        if (viewModel.isGameOver && !_dialogShown) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showGameDialog(context, viewModel);
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nulldle',
                    style: kNulldleTextStyle.copyWith(
                        fontSize: 24, color: Colors.white)),
                Text('Time: $timeString',
                    style: kNulldleTextStyle.copyWith(
                        fontSize: 18, color: Colors.white)),
              ],
            ),
            backgroundColor: kPrimaryColor,
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: GameGrid(
                    guesses: viewModel.guesses,
                    getTileColor: viewModel.getTileColor,
                  ),
                ),
                TextField(
                  controller: _controller,
                  maxLines: 1,
                  maxLength: kWordLength,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submitGuess(context, viewModel),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter your 5-letter guess",
                    counterText: "",
                  ),
                  enabled: !viewModel.isGameOver,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: viewModel.isGameOver
                          ? null
                          : () => _submitGuess(context, viewModel),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: Text("Submit",
                          style: kNulldleTextStyle.copyWith(
                              fontSize: 18, color: Colors.white)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        viewModel.resetGame();
                        _dialogShown = false; // reset here as well
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: Text("New Game",
                          style: kNulldleTextStyle.copyWith(
                              fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Keyboard(keyboardColors: viewModel.keyboardColors),
              ],
            ),
          ),
        );
      },
    );
  }
}

