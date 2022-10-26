import 'sq_collection.dart';

class InMemoryCollection extends SQCollection {
  InMemoryCollection({
    required super.id,
    required super.fields,
    String? singleDocName,
    super.parentDoc,
    super.readOnly,
    super.updates,
    super.adds,
    super.deletes,
    super.docScreen,
    super.actions,
  });

  @override
  loadCollection() async {}

  @override
  Future<void> saveCollection() async {}
}
