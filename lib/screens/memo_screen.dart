import 'package:flutter/material.dart';
import 'package:womomemo/models/memo.dart';
import 'package:womomemo/services/auth.dart';
import 'package:womomemo/services/rtdb.dart';

class MemoScreen extends StatefulWidget {
  const MemoScreen({super.key, required this.memoKey, this.memo});

  final String memoKey;
  final Memo? memo;

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  late final TextEditingController titleController, contentController;
  bool removing = false;
  bool archive = false;
  bool checkbox = false;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.memo?.title);
    contentController = TextEditingController(text: widget.memo?.content);
    archive = widget.memo?.archive ?? false;
    checkbox = widget.memo?.checkbox ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: "title-${widget.memoKey}",
          child: Material(
            type: MaterialType.transparency,
            child: TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Hero(
          tag: "content-${widget.memoKey}",
          child: Material(
            type: MaterialType.transparency,
            child: TextFormField(
              controller: contentController,
              maxLines: null,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(16),
                hintText: "Content",
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                onPressed: handleAddingCheck,
                icon: const Icon(Icons.add_box_rounded),
              ),
              IconButton(
                onPressed: handleColor,
                icon: const Icon(Icons.palette_rounded),
              ),
              const Expanded(child: SizedBox()),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.archive_rounded),
              ),
              IconButton(
                onPressed: handleDelete,
                icon: const Icon(Icons.delete_forever_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    if (removing) return;

    await RTDB.instance.ref("memos/${Auth.user!.uid}/${widget.memoKey}").set({
      "title": titleController.text,
      "content": contentController.text,
    });
  }

  void handleAddingCheck() {}
  void handleColor() {}
  void handleDelete() {
    RTDB.instance.ref("memos/${Auth.user!.uid}/${widget.memoKey}").remove();
    removing = true;
    Navigator.pop(context);
  }
}
