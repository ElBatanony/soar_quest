import 'sq_collection.dart';

class InMemoryCollection extends SQCollection {
  InMemoryCollection({
    required super.id,
    required super.fields,
    String? singleDocName,
    super.parentDoc,
    super.readOnly,
    super.canDeleteDoc,
    super.docScreen,
    super.actions,
  });

  @override
  loadCollection() async => initialized = true;

  @override
  saveDoc(SQDoc doc) async => docs.add(doc);

  @override
  loadDoc(SQDoc doc) async => {};

  @override
  deleteDoc(SQDoc doc) async => docs.removeWhere((d) => d.id == doc.id);
}
