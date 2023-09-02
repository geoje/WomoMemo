import 'package:firebase_database/firebase_database.dart';

class Memo {
  Memo({
    this.title = "",
    this.content = "",
    this.color = "white",
    this.archive = false,
    this.checkbox = false,
  });
  Memo.fromSnapshot(DataSnapshot snapshot)
      : title = snapshot.child("title").value.toString(),
        content = snapshot.child("content").value.toString(),
        color = (snapshot.child("color").value ?? Memo().color).toString(),
        archive = (snapshot.child("archive").value ?? Memo().archive) as bool,
        checkbox =
            (snapshot.child("checkbox").value ?? Memo().checkbox) as bool,
        delete = DateTime.parse(snapshot.child("delete").value.toString());

  String title, content, color;
  bool archive, checkbox;
  DateTime? delete;

  Map<String, dynamic> toJson() {
    return ({
      "title": title,
      "content": content,
      "color": color,
      "archive": archive,
      "checkbox": checkbox,
      "delete": delete?.toIso8601String(),
    });
  }
}
