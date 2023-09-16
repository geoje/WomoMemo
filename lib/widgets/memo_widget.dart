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
            if (memo.title.isEmpty)
              const SizedBox.shrink()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      memo.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  memo.archive
                      ? Icon(
                          Icons.archive_outlined,
                          size: 16,
                          color: Colors.black.withAlpha(140),
                        )
                      : memo.delete != null
                          ? Icon(
                              Icons.auto_delete_outlined,
                              size: 16,
                              color: Colors.red.withAlpha(DateTime.now()
                                          .difference(memo.delete!)
                                          .inDays >
                                      28
                                  ? 240
                                  : 100),
                            )
                          : const SizedBox.shrink(),
                ],
              ),
            if (memo.title.isEmpty || memo.content.isEmpty)
              const SizedBox.shrink()
            else
              Divider(
                color: ColorMap.border(memo.color),
              ),
            if (memo.content.isEmpty)
              const SizedBox.shrink()
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 160),
                child: memo.checked == null
                    ? SingleChildScrollView(
                        child: Text(
                          memo.content,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    : ListView(
                        shrinkWrap: true,
                        children: [
                          for (var entry
                              in memo.content.split("\n").asMap().entries)
                            Row(
                              key: Key(entry.key.toString()),
                              children: [
                                Transform.scale(
                                  scale: 0.6,
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: IgnorePointer(
                                      child: Checkbox(
                                        activeColor: Colors.grey,
                                        value:
                                            memo.checked?.contains(entry.key),
                                        onChanged: (value) {},
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    entry.value,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      decoration:
                                          memo.checked!.contains(entry.key)
                                              ? TextDecoration.lineThrough
                                              : null,
                                      color: memo.checked!.contains(entry.key)
                                          ? Colors.grey
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
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
