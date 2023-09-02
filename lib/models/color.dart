import 'package:flutter/material.dart';

class ColorMap {
  static final defaultBackColor = Colors.yellow.shade100;
  static final defaultBorderColor = Colors.yellow.shade300;

  static Map<String, MaterialColor> colors = {
    "pink": Colors.pink,
    "red": Colors.red,
    "deepOrange": Colors.deepOrange,
    "orange": Colors.orange,
    "amber": Colors.amber,
    "yellow": Colors.yellow,
    "lime": Colors.lime,
    "lightGreen": Colors.lightGreen,
    "green": Colors.green,
    "teal": Colors.teal,
    "cyan": Colors.cyan,
    "lightBlue": Colors.lightBlue,
    "blue": Colors.blue,
    "indigo": Colors.indigo,
    "purple": Colors.purple,
    "deepPurple": Colors.deepPurple,
    "blueGrey": Colors.blueGrey,
    "brown": Colors.brown,
    "grey": Colors.grey,
    "black": const MaterialColor(
      0xFF000000,
      <int, Color>{
        12: Colors.black12,
        26: Colors.black26,
        38: Colors.black38,
        45: Colors.black45,
        54: Colors.black54,
        87: Colors.black87,
      },
    ),
    "white": const MaterialColor(
      0xFFFFFFFFF,
      <int, Color>{
        10: Colors.white10,
        12: Colors.white12,
        24: Colors.white24,
        30: Colors.white30,
        38: Colors.white38,
        54: Colors.white54,
        60: Colors.white60,
        70: Colors.white70,
      },
    ),
  };

  static Color background(String color) {
    return (color == "black"
            ? Colors.black
            : color == "white"
                ? Colors.white
                : colors[color]?[100]) ??
        defaultBackColor;
  }

  static Color border(String color) {
    return (color == "black"
            ? Colors.white12
            : color == "white"
                ? Colors.black12
                : colors[color]?[200]) ??
        defaultBorderColor;
  }
}
