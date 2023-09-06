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
        delete = DateTime.tryParse(snapshot.child("delete").value.toString()) {
    var checkedObj = snapshot.child("checked").value;
    if (checkedObj != null) {
      checked = {
        ...checkedObj.toString().split(",").map((e) => int.tryParse(e) ?? -1)
      };
      checked!.remove(-1);
    }
  }

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
      "checked": checked?.join(","),
      "delete": delete?.toIso8601String(),
    });
  }
}
