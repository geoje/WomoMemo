class Memo {
  Memo(
      {this.title = "",
      this.content = "",
      this.color = "white",
      this.archive = false,
      this.checkbox = false});

  String title, content, color;
  bool archive, checkbox;
}
