import 'package:flutter/material.dart';

const List<Color> meterColors = [
  Colors.blue,
  Colors.orange,
  Colors.green,
  Colors.red,
  Colors.purple,
  Colors.brown,
  Colors.pink,
  Colors.grey,
  Colors.cyan,
  Colors.yellow,
  Colors.lime,
  Colors.indigo,
  Colors.teal,
  Colors.amber,
];

Color getMeterColor(int index) {
  return meterColors[index % meterColors.length];
}

int _nextColor = 0;

Color pickNextColor() {
  final color = getMeterColor(_nextColor);
  _nextColor += 1;
  return color;
}
