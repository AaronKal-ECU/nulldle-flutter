// lib/services/stats_service.dart
// Aaron Mark Kalaji, CSP2108, 3/11/25

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StatsService {
  static const String _statsKey = 'gameStats';
  static const String _leaderboardKey = 'leaderboard';

  // statitsics model
  Map<String, int> _stats = {
    'wins': 0,
    'losses': 0,
    'totalGames': 0,
    'totalIncorrectGuesses': 0,
  };

  Map<String, int> get stats => _stats;

  // leaderboard modle 
  // stores a list of maps
  List<Map<String, dynamic>> _leaderboard = [];

  List<Map<String, dynamic>> get leaderboard => _leaderboard;

  StatsService() {
    _loadStats();
    _loadLeaderboard();
  }

  // persistence methods
  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString(_statsKey);
    if (statsJson != null) {
      _stats = Map<String, int>.from(jsonDecode(statsJson));
    }
  }

  Future<void> _saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statsKey, jsonEncode(_stats));
  }

  Future<void> _loadLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    final leaderboardJson = prefs.getString(_leaderboardKey);
    if (leaderboardJson != null) {
      // decode the list of maps
      final List<dynamic> decodedList = jsonDecode(leaderboardJson);
      _leaderboard = decodedList.map((item) => Map<String, dynamic>.from(item)).toList();
      _sortLeaderboard();
    }
  }

  Future<void> _saveLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_leaderboardKey, jsonEncode(_leaderboard));
  }

  // update methods
  void recordWin(int timeInSeconds, int incorrectGuesses) {
    _stats['wins'] = (_stats['wins'] ?? 0) + 1;
    _stats['totalGames'] = (_stats['totalGames'] ?? 0) + 1;
    _stats['totalIncorrectGuesses'] = (_stats['totalIncorrectGuesses'] ?? 0) + incorrectGuesses;
    _saveStats();
    _addLeaderboardEntry(timeInSeconds);
  }

  void recordLoss(int incorrectGuesses) {
    _stats['losses'] = (_stats['losses'] ?? 0) + 1;
    _stats['totalGames'] = (_stats['totalGames'] ?? 0) + 1;
    _stats['totalIncorrectGuesses'] = (_stats['totalIncorrectGuesses'] ?? 0) + incorrectGuesses;
    _saveStats();
  }

  void _addLeaderboardEntry(int timeInSeconds) {
    _leaderboard.add({
      'time': timeInSeconds,
      'date': DateTime.now().toIso8601String().substring(0, 10), // YYYY-MM-DD
    });
    _sortLeaderboard();
    _saveLeaderboard();
  }

  void _sortLeaderboard() {
    // sort by time taken (ascending: faster is better)
    _leaderboard.sort((a, b) => a['time'].compareTo(b['time']));
    // top 10 entries only
    if (_leaderboard.length > 10) {
      _leaderboard = _leaderboard.sublist(0, 10);
    }
  }

  // display 
  String formatTime(int timeInSeconds) {
    final minutes = (timeInSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (timeInSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
