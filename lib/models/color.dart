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
    "clear": const MaterialColor(0, {}),
  };

  static Color background(String color) {
    return (color == "clear" ? Colors.white : colors[color]?[100]) ??
        defaultBackColor;
  }

  static Color border(String color) {
    return (color == "clear" ? Colors.black12 : colors[color]?[200]) ??
        defaultBorderColor;
  }
}
