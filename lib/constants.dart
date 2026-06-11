import 'package:flutter/material.dart';
// Aaron KALAJI 10670705 CSP2108 1/11/25

// colours
const Color kGreen = Color(0xFF6AAA64); // correct letter, correct spot
const Color kYellow = Color(0xFFC9B458); // correct letter, wrong spot
const Color kGrey = Color(0xFF787C7E); // ketter not in word
const Color kLightGrey = Color(0xFFD3D6DA); // default tile/key colour
const Color kBlack = Color(0xFF212121); // text colour / Miss colour

// styles
const String kFontFamily = 'Courier';
const Color kPrimaryColor = Colors.blue;

const TextStyle kNulldleTextStyle = TextStyle(
  fontFamily: kFontFamily,
  color: kPrimaryColor,
  fontWeight: FontWeight.bold,
);

const TextStyle kTileTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

const TextStyle kKeyboardTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

// constants
const int kWordLength = 5;
const int kMaxGuesses = 6; // changed from 5 to 6
const String kKeyboardLayout = 'QWERTYUIOPASDFGHJKLZXCVBNM';

/// initialises keyboard
Map<String, Color> initializeKeyboardColors() {
  return {
    for (var c in kKeyboardLayout.split('')) c: kLightGrey,
  };
}
