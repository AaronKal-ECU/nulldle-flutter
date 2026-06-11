// lib/model/game_tile.dart
// Aaron KALAJI 10670705 CSP2108 1/11/25

import 'package:flutter/material.dart';
import 'tile_match.dart';

/// Represents a single tile on the game board.
class GameTile {
  final String letter;
  final TileMatch match;

  GameTile({required this.letter, this.match = TileMatch.none});

  Color get color => match.color;
}
