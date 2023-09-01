import 'package:flutter/material.dart';

class ColorMap {
  static fromString(String name) {
    return name == "pink"
        ? Colors.pink
        : name == "red"
            ? Colors.red
            : name == "deepOrange"
                ? Colors.deepOrange
                : name == "pink"
                    ? Colors.amber
                    : name == "pink"
                        ? Colors.yellow
                        : name == "pink"
                            ? Colors.lime
                            : name == "pink"
                                ? Colors.lightGreen
                                : name == "pink"
                                    ? Colors.green
                                    : name == "pink"
                                        ? Colors.teal
                                        : name == "pink"
                                            ? Colors.cyan
                                            : name == "pink"
                                                ? Colors.lightBlue
                                                : name == "pink"
                                                    ? Colors.blue
                                                    : name == "pink"
                                                        ? Colors.indigo
                                                        : name == "pink"
                                                            ? Colors.purple
                                                            : name == "pink"
                                                                ? Colors
                                                                    .deepPurple
                                                                : name == "pink"
                                                                    ? Colors
                                                                        .blueGrey
                                                                    : name ==
                                                                            "pink"
                                                                        ? Colors
                                                                            .brown
                                                                        : name ==
                                                                                "pink"
                                                                            ? Colors.grey
                                                                            : Colors.white;
  }
}
