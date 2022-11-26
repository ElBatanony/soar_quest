class SQUpdates {
  const SQUpdates({
    this.edits = true,
    this.adds = true,
    this.deletes = true,
  });

  SQUpdates.readOnly() : this(edits: false, adds: false, deletes: false);

  final bool edits, adds, deletes;

  bool get readOnly => !edits && !adds && !deletes;

  SQUpdates operator &(SQUpdates other) => SQUpdates(
        edits: edits && other.edits,
        adds: adds && other.adds,
        deletes: deletes && other.deletes,
      );
}
