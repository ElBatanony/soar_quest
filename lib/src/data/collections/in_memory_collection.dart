import '../sq_collection.dart';

export '../sq_collection.dart';

class InMemoryCollection extends SQCollection {
  InMemoryCollection({
    required super.id,
    required super.fields,
    super.parentDoc,
    super.updates,
    super.actions,
    super.filters,
  });

  @override
  loadCollection() async {}

  @override
  Future<void> saveCollection() async {}
}
