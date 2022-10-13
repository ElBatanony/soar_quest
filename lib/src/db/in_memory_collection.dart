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
  loadCollection() async => super.loadCollection();

  @override
  loadDoc(SQDoc doc) async => docs.singleWhere((e) => e.id == doc.id);

  @override
  saveDoc(SQDoc doc) async => docs.add(doc);
}
