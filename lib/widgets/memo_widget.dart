import 'package:flutter/material.dart';
import 'package:womomemo/models/color.dart';
import 'package:womomemo/models/memo.dart';
import 'package:womomemo/screens/memo_screen.dart';

class MemoWidget extends StatelessWidget {
  const MemoWidget({super.key, required this.memoKey, required this.memo});

  final String memoKey;
  final Memo memo;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () => handleEdit(context, memoKey),
      style: FilledButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: ColorMap.background(memo.color),
        padding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: ColorMap.border(memo.color)),
        elevation: 0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            memo.title.isEmpty ? const SizedBox.shrink() : Text(memo.title),
            memo.title.isEmpty
                ? const SizedBox.shrink()
                : Divider(
                    color: ColorMap.border(memo.color),
                  ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 160),
              child: Text(
                memo.content,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
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
