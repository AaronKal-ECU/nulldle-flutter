import 'package:flutter/material.dart';
import 'constants.dart';
// Aaron KALAJI 10670705 CSP2108 1/11/25

typedef TileColorGetter = Color Function(String guess, int index);

class GameGrid extends StatelessWidget {
  final List<String> guesses;
  final TileColorGetter getTileColor;

  const GameGrid({
    super.key,
    required this.guesses,
    required this.getTileColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(kMaxGuesses, (rowIndex) {
        String? guess = rowIndex < guesses.length ? guesses[rowIndex] : null;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(kWordLength, (colIndex) {
            String letter = '';
            Color bgColor = kLightGrey;

            if (guess != null && colIndex < guess.length) {
              letter = guess[colIndex].toUpperCase();
              bgColor = getTileColor(guess, colIndex);
            }

            return Container(
              margin: const EdgeInsets.all(4.0),
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black26),
              ),
              child: Text(
                letter,
                style: kTileTextStyle,
              ),
            );
          }),
        );
      }),
    );
  }
}
