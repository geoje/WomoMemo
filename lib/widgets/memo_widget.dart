import 'package:flutter/material.dart';
import 'package:womomemo/models/memo.dart';
import 'package:womomemo/screens/memo_screen.dart';

class MemoWidget extends StatelessWidget {
  const MemoWidget({super.key, required this.memoKey, required this.memo});

  final String memoKey;
  final Memo memo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: FilledButton(
        onPressed: () => handleEdit(context, memoKey),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.yellow,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: const BorderSide(color: Colors.red),
        ),
        child: Column(children: [
          Hero(
            tag: "title-$memoKey",
            child: Material(
              type: MaterialType.transparency,
              child: Text(memo.title),
            ),
          ),
          Hero(
            tag: "content-$memoKey",
            child: Material(
              type: MaterialType.transparency,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 160),
                child: Text(memo.content),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void handleEdit(BuildContext context, String key) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoScreen(
          memoKey: memoKey,
          memo: memo,
        ),
      ),
    );
  }
}
