class SQFile {
  bool exists;

  SQFile({this.exists = false});

  static SQFile? parse(dynamic source) {
    dynamic exists = source["exists"];

    if (exists == null || exists is! bool) return null;

    return SQFile(exists: exists);
  }

  @override
  String toString() {
    return exists ? "file" : "file not set";
  }
}
