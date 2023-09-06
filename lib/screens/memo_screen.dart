import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:womomemo/models/checkItem.dart';
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
  late final TextEditingController titleController,
      contentController,
      addController;
  late Memo memo;
  late List<CheckItem> checkItems = [];

  Timer? paletteTimer;
  bool removing = false;

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_onKey);

    titleController = TextEditingController(text: widget.memo?.title);
    contentController = TextEditingController(text: widget.memo?.content);
    addController = TextEditingController();
    memo = widget.memo ?? Memo();
    if (memo.checked != null) {
      memo.content.split("\n").asMap().forEach((key, value) =>
          checkItems.add(CheckItem(checked: memo.checked!.contains(key))));
    }
  }

  @override
  void dispose() async {
    ServicesBinding.instance.keyboard.removeHandler(_onKey);

    paletteTimer?.cancel();
    super.dispose();
    if (removing) return;

    memo.title = titleController.text;
    memo.content = contentController.text;
    if (checkItems.isNotEmpty) {
      memo.checked = {};
      // dodododo
    }
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
          style: const TextStyle(fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            hintText: "Title",
            border: InputBorder.none,
          ),
        ),
      ),
      body: memo.checked == null
          ? SingleChildScrollView(
              child: TextFormField(
              controller: contentController,
              maxLines: null,
              style: const TextStyle(fontWeight: FontWeight.w400),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(16),
                hintText: "Content",
                border: InputBorder.none,
              ),
            ))
          : Theme(
              data: ThemeData(canvasColor: ColorMap.background(memo.color)),
              child: ReorderableListView(
                onReorder: handleReorder,
                children: [
                  for (int i = 0; i < checkItems.length; i++)
                    CheckboxListTile(
                      key: Key(i.toString()),
                      title: TextFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        initialValue: checkItems[i].controller.text,
                        style: memo.checked!.contains(i)
                            ? const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                      secondary: const Icon(Icons.drag_handle),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      activeColor: Colors.grey,
                      value: memo.checked?.contains(i),
                      onChanged: (value) {
                        if (value == null || !value) {
                          memo.checked?.remove(i);
                        } else {
                          memo.checked?.add(i);
                        }
                        setState(() {});
                      },
                    ),
                  ListTile(
                    key: const Key("Add"),
                    leading: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.add),
                    ),
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    title: TextField(
                      controller: addController,
                      decoration: const InputDecoration(
                        hintText: "List Item",
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onSubmitted: (value) {
                        memo.content += "\n$value";
                        addController.text = "";
                        setState(() {});
                      },
                    ),
                  )
                ],
              ),
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.black.withAlpha(20)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: memo.delete == null
              ? Row(
                  children: [
                    Tooltip(
                      message: memo.checked == null
                          ? "Enable Checkbox"
                          : "Disable Checkbox",
                      child: IconButton(
                        onPressed: handleAddingCheck,
                        icon: Icon(memo.checked == null
                            ? Icons.checklist
                            : Icons.indeterminate_check_box),
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
                          memo.archive
                              ? Icons.unarchive_outlined
                              : Icons.archive,
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
                )
              : Row(children: [
                  Tooltip(
                    message: "Restore",
                    child: IconButton(
                      onPressed: handleRestore,
                      icon: const Icon(Icons.restore),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Tooltip(
                    message: "Delete Forever",
                    child: IconButton(
                      onPressed: handleDeleteForever,
                      icon: const Icon(Icons.delete_forever),
                    ),
                  ),
                ]),
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
    setState(() => memo.checked = memo.checked == null ? {} : null);
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
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            backgroundColor: ColorMap.background(colorKey),
                            side: BorderSide(
                              color: ColorMap.border(colorKey),
                              width: 1,
                            ),
                          ),
                          onPressed: () {
                            setState(() => memo.color = colorKey);
                            ScaffoldMessenger.of(context).clearSnackBars();
                            paletteTimer!.cancel();
                            paletteTimer = null;
                          },
                          child: memo.color == colorKey
                              ? Icon(
                                  Icons.check,
                                  color: Colors.black.withAlpha(180),
                                )
                              : null,
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
    Navigator.pop(context);
  }

  void handleDelete() {
    memo.delete = DateTime.now();
    Navigator.pop(context);
  }

  void handleRestore() {
    memo.delete = null;
    Navigator.pop(context);
  }

  void handleDeleteForever() {
    RTDB.instance.ref("memos/${Auth.user!.uid}/${widget.memoKey}").remove();
    removing = true;
    Navigator.pop(context);
  }

  void handleReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;

    // Update content
    var lines = memo.content.split("\n");
    var line = lines[oldIndex];
    lines.removeAt(oldIndex);
    lines.insert(newIndex, line);
    memo.content = lines.join("\n");

    // Update checked
    var moveValue = memo.checked!.contains(oldIndex);
    if (newIndex > oldIndex) {
      for (int i = oldIndex; i < newIndex; i++) {
        if (memo.checked!.contains(i + 1)) {
          memo.checked!.add(i);
        } else {
          memo.checked!.remove(i);
        }
      }
    } else {
      for (int i = oldIndex; i > newIndex; i--) {
        if (memo.checked!.contains(i - 1)) {
          memo.checked!.add(i);
        } else {
          memo.checked!.remove(i);
        }
      }
    }
    if (moveValue) memo.checked!.add(newIndex);

    setState(() {});
  }
}
