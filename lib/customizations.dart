import 'dart:math';
import 'package:flutter/material.dart';

final List<Color> _colorPalette = [
  Colors.amber[200],
  Colors.blue[200],
  Colors.cyan[200],
  Colors.deepOrange[200],
  Colors.deepPurple[200],
  Colors.green[200],
  Colors.indigo[200],
  Colors.lightBlue[200],
  Colors.lightGreen[200],
  Colors.lime[200],
  Colors.orange[200],
  Colors.pink[200],
  Colors.purple[200],
  Colors.red[200],
  Colors.teal[200],
  Colors.yellow[200],
];

const List<String> _adjectives = [
  "Happy",
  "Sad",
  "Angry",
  "Indignant",
  "Annoyed",
  "Blue",
  "Charming",
  "Clumsy",
  "Funny",
  "Cute",
  "Confused",
  "Defiant",
  "Bubbly",
];
const List<String> _nouns = [
  "Capybara",
  "Rhino",
  "Panda",
  "Kangaroo",
  "Platypus",
  "Puppy",
  "Kitten",
  "Spider",
  "Penguin",
  "Owl",
  "Bear",
  "Frog",
  "Axolotl",
];

/// get a random color from a list of preselected colors
getDeterministicColor(String seed) {
  final index = seed.codeUnits.reduce((a, b) => a + b) % _colorPalette.length;

  return _colorPalette[index];
}

/// get a random name based on a list of adjectives & adverbs
getRandomName() {
  String begin = getRandomItemFromArray(_adjectives);
  String end = getRandomItemFromArray(_nouns);
  return "$begin $end";
}

/// get a random element from an array
final Random _random = new Random();
T getRandomItemFromArray<T>(List<T> items) {
  return items[_random.nextInt(items.length)];
}
