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
  int slectedIndex = -1;

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_onKey);

    titleController = TextEditingController(text: widget.memo?.title);
    contentController = TextEditingController(text: widget.memo?.content);
    addController = TextEditingController();
    memo = widget.memo ?? Memo();
    if (memo.checked != null) handleAddingCheck();
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
      for (int i = 0; i < checkItems.length; i++) {
        if (checkItems[i].checked) {
          memo.checked!.add(i);
        }
      }
      memo.content = checkItems.map((e) => e.controller.text).join("\n");
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
      body: checkItems.isEmpty
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
                        controller: checkItems[i].controller,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: checkItems[i].checked
                            ? const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              )
                            : null,
                        onTap: () {
                          setState(() => slectedIndex = i);
                          print("[onTap] $slectedIndex");
                        },
                        // onTapOutside: (event) {
                        //   if (slectedIndex == i) {
                        //     setState(() => slectedIndex = -1);
                        //     print("[onTapOutside] $slectedIndex");
                        //   }
                        // },
                      ),
                      secondary: SizedBox(
                        width: 72,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.close,
                                  size: 16,
                                )),
                            const Icon(Icons.drag_handle),
                          ],
                        ),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      activeColor: Colors.grey,
                      value: checkItems[i].checked,
                      onChanged: (value) {
                        checkItems[i].checked = value ?? false;
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
                      onSubmitted: handleAdd,
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
                      message: checkItems.isEmpty
                          ? "Enable Checkbox"
                          : "Disable Checkbox",
                      child: IconButton(
                        onPressed: handleAddingCheck,
                        icon: Icon(checkItems.isEmpty
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
    if (checkItems.isNotEmpty) {
      checkItems.clear();
      memo.checked = null;
    } else {
      memo.checked ??= {};
      contentController.text
          .split("\n")
          .asMap()
          .forEach((key, value) => checkItems.add(CheckItem(
                checked: memo.checked!.contains(key),
                text: value,
              )));
    }
    setState(() => {});
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
    checkItems.insert(newIndex, checkItems[oldIndex]);
    checkItems.removeAt(oldIndex + (newIndex < oldIndex ? 1 : 0));
    setState(() {});
  }

  void handleAdd(String value) {
    checkItems.add(CheckItem(checked: false, text: value));
    addController.text = "";
    setState(() {});
  }
}
