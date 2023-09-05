import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:womomemo/models/color.dart';
import 'package:womomemo/models/memo.dart';
import 'package:womomemo/services/auth.dart';
import 'package:womomemo/services/rtdb.dart';

class MemoScreen extends StatefulWidget {
  MemoScreen({super.key, required this.memoKey, this.memo});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final String memoKey;
  final Memo? memo;

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  late final TextEditingController titleController, contentController;
  late Memo memo;

  Timer? paletteTimer;
  bool removing = false;

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_onKey);

    titleController = TextEditingController(text: widget.memo?.title);
    contentController = TextEditingController(text: widget.memo?.content);
    memo = widget.memo ?? Memo();
  }

  @override
  void dispose() async {
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    paletteTimer?.cancel();
    super.dispose();
    if (removing) return;

    memo.title = titleController.text;
    memo.content = contentController.text;
    await RTDB.instance
        .ref("memos/${Auth.user!.uid}/${widget.memoKey}")
        .set(memo.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      backgroundColor: ColorMap.background(memo.color),
      appBar: AppBar(
        backgroundColor: ColorMap.background(memo.color),
        title: TextFormField(
          controller: titleController,
          decoration: const InputDecoration(
            hintText: "Title",
            border: InputBorder.none,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: TextFormField(
          controller: contentController,
          maxLines: null,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(16),
            hintText: "Content",
            border: InputBorder.none,
          ),
          style: const TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.black.withAlpha(20)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Tooltip(
                message: memo.checkbox ? "Disable Checkbox" : "Enable Checkbox",
                child: IconButton(
                  onPressed: handleAddingCheck,
                  icon: Icon(memo.checkbox
                      ? Icons.indeterminate_check_box
                      : Icons.checklist),
                ),
              ),
              Tooltip(
                message: "Set Color",
                child: IconButton(
                  onPressed: handleColor,
                  icon: const Icon(Icons.palette),
                ),
              ),
              const Expanded(child: SizedBox()),
              Tooltip(
                message: memo.archive ? "Unarchive" : "Archive",
                child: IconButton(
                  onPressed: handleArchive,
                  icon: Icon(
                    memo.archive ? Icons.unarchive_outlined : Icons.archive,
                  ),
                ),
              ),
              Tooltip(
                message: "Delete",
                child: IconButton(
                  onPressed: handleDelete,
                  icon: const Icon(Icons.delete),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _onKey(KeyEvent event) {
    final key = event.logicalKey.keyLabel;
    if (key == "Escape") {
      Navigator.pop(context);
      ServicesBinding.instance.keyboard.removeHandler(_onKey);
      return true;
    }
    return false;
  }

  void handleAddingCheck() {
    setState(() => memo.checkbox = !memo.checkbox);
  }

  void handleColor() {
    if (paletteTimer != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      paletteTimer!.cancel();
      paletteTimer = null;
    } else {
      paletteTimer = Timer(const Duration(minutes: 1), () {
        ScaffoldMessenger.of(context).clearSnackBars();
        paletteTimer = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(minutes: 1),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          content: Center(
            child: Wrap(
              children: [
                for (String colorKey in ColorMap.colors.keys)
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: Tooltip(
                        message: colorKey,
                        verticalOffset: -48,
                        showDuration: const Duration(milliseconds: 50),
                        child: ElevatedButton(
                          child: null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorMap.background(colorKey),
                            side: BorderSide(
                                color: ColorMap.border(colorKey),
                                width: memo.color == colorKey ? 2 : 1),
                          ),
                          onPressed: () {
                            setState(() => memo.color = colorKey);
                          },
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      );
    }
  }

  void handleArchive() {
    setState(() => memo.archive = !memo.archive);
  }

  void handleDelete() {
    RTDB.instance.ref("memos/${Auth.user!.uid}/${widget.memoKey}").remove();
    removing = true;
    Navigator.pop(context);
  }
}
