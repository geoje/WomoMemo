class Memo {
  Memo(
      {this.title = "",
      this.content = "",
      this.archive = false,
      this.checkbox = false});

  String title, content;
  bool archive, checkbox;
}
