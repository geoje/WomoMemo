import 'package:firebase_database/firebase_database.dart';

class Memo {
  Memo({
    this.title = "",
    this.content = "",
    this.color = "white",
    this.archive = false,
  });
  Memo.fromSnapshot(DataSnapshot snapshot)
      : title = snapshot.child("title").value.toString(),
        content = snapshot.child("content").value.toString(),
        color = (snapshot.child("color").value ?? Memo().color).toString(),
        archive = (snapshot.child("archive").value ?? Memo().archive) as bool,
        // checked = (snapshot.child("checked").value ?? {}) as Set<int>,
        delete = DateTime.tryParse(snapshot.child("delete").value.toString());

  String title, content, color;
  bool archive;
  Set<int>? checked;
  DateTime? delete;

  Map<String, dynamic> toJson() {
    return ({
      "title": title,
      "content": content,
      "color": color,
      "archive": archive,
      "checked": checked,
      "delete": delete?.toIso8601String(),
    });
  }
}
