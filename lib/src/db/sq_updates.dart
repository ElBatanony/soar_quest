class SQUpdates {
  final bool edits, adds, deletes;

  const SQUpdates({
    this.edits = true,
    this.adds = true,
    this.deletes = true,
  });

  SQUpdates.readOnly() : this(edits: false, adds: false, deletes: false);

  bool get readOnly => !edits && !adds && !deletes;

  SQUpdates operator &(SQUpdates other) {
    return SQUpdates(
      edits: edits && other.edits,
      adds: adds && other.adds,
      deletes: deletes && other.deletes,
    );
  }
}
