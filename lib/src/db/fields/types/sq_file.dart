class SQFile {
  String fieldName;
  bool exists;

  SQFile({
    required this.fieldName,
    this.exists = false,
  });

  static SQFile? parse(dynamic source) {
    bool exists = source["exists"] ?? false;
    String? fieldName = source["fieldName"];

    if (fieldName == null) return null;

    return SQFile(fieldName: fieldName, exists: exists);
  }

  @override
  String toString() {
    return exists ? "file" : "file not set";
  }
}
