import 'package:flutter/material.dart';

class AuthHeaderWidget extends StatelessWidget {
  const AuthHeaderWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 80),
      SizedBox(
        width: 100,
        height: 100,
        child: Image.asset("assets/Icon-512.png"),
      ),
      const SizedBox(height: 10),
      Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
      ),
      const SizedBox(height: 80)
    ]);
  }
}
