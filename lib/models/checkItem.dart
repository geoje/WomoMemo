import 'package:flutter/material.dart';

class CheckItem {
  CheckItem({this.checked = false, String text = ""})
      : controller = TextEditingController(text: text);

  bool checked;
  final TextEditingController controller;
}
