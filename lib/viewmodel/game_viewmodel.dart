// lib/viewmodel/game_viewmodel.dart
// Aaron KALAJI 10670705 CSP2108 2/11/25

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../constants.dart';
import '../model/game_state.dart';
import '../model/tile_match.dart';
import '../services/stats_service.dart';

class GameViewModel extends ChangeNotifier {
  // state variables (private)
  GameState _gameState = GameState.loading;
  List<String> _dictionary = [];
  String _targetWord = '';
  final List<String> _guesses = [];
  Map<String, Color> _keyboardColors = initializeKeyboardColors();
  final StatsService _statsService = StatsService();
  final Stopwatch _stopwatch = Stopwatch();
  int _incorrectGuessesInGame = 0;

  // getters (public)
  GameState get gameState => _gameState;
  String get targetWord => _targetWord;
  List<String> get guesses => _guesses;
  Map<String, Color> get keyboardColors => _keyboardColors;
  bool get isGameOver => _gameState == GameState.won || _gameState == GameState.lost;
  StatsService get statsService => _statsService;
  int get timeElapsed => _stopwatch.elapsed.inSeconds;

  GameViewModel() {
    _loadDictionary();
  }

  void _startGameTimer() {
    _stopwatch.reset();
    _stopwatch.start();
  }

  void _stopGameTimer() {
    _stopwatch.stop();
  }

  // initialisation
  Future<void> _loadDictionary() async {
    try {
      final dict = await rootBundle.loadString('assets/english_dict.txt');
      _dictionary = dict
          .split('\n')
          .map((w) => w.trim().toLowerCase())
          .where((w) => w.length == kWordLength)
          .toList();

      _targetWord = _dictionary[Random().nextInt(_dictionary.length)];
      _gameState = GameState.playing;
      _startGameTimer();
    } catch (e) {
      // Handle error loading dictionary
      _gameState = GameState.lost;
    }
    notifyListeners();
  }

  // --- Game Logic ---
  TileMatch getTileMatch(String guess, int index) {
    final letter = guess[index];
    final target = _targetWord;

    if (target[index] == letter) {
      return TileMatch.correct;
    } else if (target.contains(letter)) {
      return TileMatch.present;
    } else {
      return TileMatch.miss;
    }
  }

  Color getTileColor(String guess, int index) {
    return getTileMatch(guess, index).color;
  }

  void _updateKeyboard(String guess) {
    for (int i = 0; i < guess.length; i++) {
      String letter = guess[i].toUpperCase();
      TileMatch newMatch = getTileMatch(guess, i);
      // Removed unused: Color newColor = newMatch.color;
      Color? currentColor = _keyboardColors[letter];

      // Priority order: Green > Yellow > Miss (Black) > Default (LightGrey)
      if (newMatch == TileMatch.correct) {
        _keyboardColors[letter] = kGreen;
      } else if (newMatch == TileMatch.present && currentColor != kGreen) {
        _keyboardColors[letter] = kYellow;
      } else if (newMatch == TileMatch.miss && currentColor == kLightGrey) {
        _keyboardColors[letter] = kBlack;
      }
    }
  }

  String? submitGuess(String guess) {
    final processedGuess = guess.trim().toLowerCase();

    if (processedGuess.length != kWordLength) {
      return "Word must be $kWordLength letters long!";
    }

    if (_dictionary.isEmpty || _gameState == GameState.loading) {
      return "Dictionary is still loading. Please wait.";
    }

    if (!_dictionary.contains(processedGuess)) {
      _incorrectGuessesInGame++; // Count invalid word as an incorrect guess
      return "Not a valid word!";
    }

    _guesses.add(processedGuess);
    _updateKeyboard(processedGuess);

    if (processedGuess == _targetWord) {
      _gameState = GameState.won;
    } else if (_guesses.length >= kMaxGuesses) {
      _gameState = GameState.lost;
    }

    if (_gameState == GameState.won) {
      _stopGameTimer();
      _statsService.recordWin(timeElapsed, _incorrectGuessesInGame);
    } else if (_gameState == GameState.lost) {
      _stopGameTimer();
      _statsService.recordLoss(_incorrectGuessesInGame);
    }

    notifyListeners();
    return null; // No error
  }

  void resetGame() {
    _guesses.clear();
    _keyboardColors = initializeKeyboardColors();
    _incorrectGuessesInGame = 0;
    _stopwatch.reset();
    if (_dictionary.isNotEmpty) {
      _targetWord = _dictionary[Random().nextInt(_dictionary.length)];
      _gameState = GameState.playing;
      _startGameTimer();
    } else {
      _gameState = GameState.loading;
      _loadDictionary();
    }
    notifyListeners();
  }
}
