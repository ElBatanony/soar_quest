import 'package:uuid/uuid.dart';

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
  deleteDoc(SQDoc doc) async => docs.removeWhere((e) => e.id == doc.id);

  @override
  String getANewDocId() => Uuid().v1();

  @override
  loadCollection() async => {};

  @override
  loadDoc(SQDoc doc) async => docs.firstWhere((e) => e.id == doc.id);

  @override
  saveDoc(SQDoc doc) async =>
      docs.any((e) => e.id == doc.id) ? {} : docs.add(doc);
}
