// lib/model/tile_match.dart
// Aaron KALAJI 10670705 CSP2108 1/11/25

import 'package:flutter/material.dart';
import '../constants.dart';

/// Represents the match status of a single letter tile.
enum TileMatch {
  correct, // Green
  present, // Yellow
  miss, // Black
  none, // Default Light Grey
}

extension TileMatchExtension on TileMatch {
  Color get color {
    switch (this) {
      case TileMatch.correct:
        return kGreen;
      case TileMatch.present:
        return kYellow;
      case TileMatch.miss:
        return kBlack;
      case TileMatch.none:
        return kLightGrey;
    }
  }
}
