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

  static final List<NavItem> items = [
    NavItem(
      label: "Memos",
      iconData: Icons.sticky_note_2_outlined,
      iconDataActive: Icons.sticky_note_2,
    ),
    NavItem(
      label: "Archive",
      iconData: Icons.archive_outlined,
      iconDataActive: Icons.archive,
    ),
    NavItem(
      label: "Trash",
      iconData: Icons.delete_outline,
      iconDataActive: Icons.delete,
    )
  ];
}
