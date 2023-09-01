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

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.memo?.title);
    contentController = TextEditingController(text: widget.memo?.content);
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
              const Expanded(child: SizedBox()),
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
  void handleDelete() {
    RTDB.instance.ref("memos/Test/${widget.memoKey}").remove();
    removing = true;
    Navigator.pop(context);
  }
}
