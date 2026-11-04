import 'package:flutter/material.dart';
import 'constants.dart';
// Aaron Mark Kalaji, CSP2108, 1/11/25

class Keyboard extends StatelessWidget {
  final Map<String, Color> keyboardColors;

  const Keyboard({
    super.key,
    required this.keyboardColors,
  });

  @override
  Widget build(BuildContext context) {
    const keyboardRows = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate available width for the keyboard rows
        final availableWidth = constraints.maxWidth;

        return Column(
          children: keyboardRows.map((row) {
            // Determine the number of keys in the current row
            final keyCount = row.length;
            // Calculate the total margin space needed (4.0 on both sides of each key)
            final totalMargin = 8.0 * keyCount;
            
            // Calculate the width for each key
            final keyWidth = (availableWidth - totalMargin) / keyCount;
            // Set a fixed height for the keys
            const keyHeight = 40.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0), // Add spacing between rows
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.split('').map((letter) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: keyWidth,
                    height: keyHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: keyboardColors[letter],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.black26),
                    ),
                    child: Text(
                      letter,
                      style: kKeyboardTextStyle,
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
