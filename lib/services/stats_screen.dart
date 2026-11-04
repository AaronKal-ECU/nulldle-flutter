// lib/stats_screen.dart
// Aaron Mark Kalaji, CSP2108, 3/11/25

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/game_viewmodel.dart';
import '../constants.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GameViewModel>(context);
    final stats = viewModel.statsService.stats;
    final leaderboard = viewModel.statsService.leaderboard;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Game Statistics & Leaderboard',
          style: kNulldleTextStyle.copyWith(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Game Statistics',
              style: kNulldleTextStyle.copyWith(fontSize: 24, color: kPrimaryColor),
            ),
            const Divider(),
            _buildStatRow('Total Games Played:', stats['totalGames']?.toString() ?? '0'),
            _buildStatRow('Wins:', stats['wins']?.toString() ?? '0'),
            _buildStatRow('Losses:', stats['losses']?.toString() ?? '0'),
            _buildStatRow('Total Incorrect Guesses:', stats['totalIncorrectGuesses']?.toString() ?? '0'),
            const SizedBox(height: 30),
            Text(
              'Leaderboard',
              style: kNulldleTextStyle.copyWith(fontSize: 24, color: kPrimaryColor),
            ),
            const Divider(),
            _buildLeaderboardHeader(),
            ...leaderboard.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> record = entry.value;
              return _buildLeaderboardRow(
                (index + 1).toString(),
                viewModel.statsService.formatTime(record['time']),
                record['date'],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: kNulldleTextStyle.copyWith(fontSize: 16, color: kBlack),
          ),
          Text(
            value,
            style: kNulldleTextStyle.copyWith(fontSize: 16, color: kPrimaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          _buildLeaderboardCell('Rank', isHeader: true, flex: 1),
          _buildLeaderboardCell('Time', isHeader: true, flex: 2),
          _buildLeaderboardCell('Date', isHeader: true, flex: 3),
        ],
      ),
    );
  }

  Widget _buildLeaderboardRow(String rank, String time, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          _buildLeaderboardCell(rank, flex: 1),
          _buildLeaderboardCell(time, flex: 2),
          _buildLeaderboardCell(date, flex: 3),
        ],
      ),
    );
  }

  Widget _buildLeaderboardCell(String text, {bool isHeader = false, required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: kNulldleTextStyle.copyWith(
          fontSize: 14,
          color: isHeader ? kPrimaryColor : kBlack,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
