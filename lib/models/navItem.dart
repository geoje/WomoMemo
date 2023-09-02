import 'package:flutter/material.dart';

class NavItem {
  NavItem({
    required this.label,
    required this.iconData,
    required this.iconDataActive,
  });

  String label;
  IconData iconData;
  IconData iconDataActive;
}
