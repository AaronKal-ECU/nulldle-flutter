# Nulldle

A Wordle-style word game for mobile, built with Flutter. Guess the hidden five-letter word in six tries, with coloured tiles and an on-screen keyboard showing how close each guess was.

## What I built
- The full game loop: a random target word from a dictionary of over 11,000 five-letter words, guess validation, green/yellow/grey tile scoring, and a keyboard that remembers the best result for each letter.
- A home screen, game screen and stats screen, with a timer running on every game.
- Persistent stats (wins, losses, games played, incorrect guesses) and a top-10 fastest-wins leaderboard, saved on the device with `shared_preferences`.
- An MVVM structure: game state and rules live in a `GameViewModel` shared through `provider`, separate from the UI widgets, plus widget tests for the home and game screens.

## Tools & tech
Dart, Flutter, provider, shared_preferences, flutter_test.

## What I learnt
- Separating UI from game logic with MVVM and `ChangeNotifier`.
- Building responsive Flutter layouts from reusable widgets (grid, tiles, keyboard).
- Loading bundled assets and saving data locally on the device.
- Writing widget tests that check screens render and navigate correctly.

## Run it
With the Flutter SDK installed:
```
flutter pub get
flutter run
```
Run the tests with `flutter test`.

Built for CSP2108 Introduction to Mobile Applications Development at Edith Cowan University, 2025.
