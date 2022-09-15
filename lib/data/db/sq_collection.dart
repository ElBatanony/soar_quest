import 'package:soar_quest/data/db/sq_doc.dart';
import 'package:soar_quest/screens/collection_screen.dart';

import '../../app.dart';

abstract class SQCollection {
  final String id;
  List<SQDocField> fields;
  List<SQDoc> docs = [];
  CollectionScreen? screen;
  late String singleDocName;
  SQDoc? parentDoc;
  bool readOnly;
  bool canDeleteDoc;

  SQCollection(
    this.id,
    this.fields, {
    String? singleDocName,
    this.parentDoc,
    this.readOnly = false,
    this.canDeleteDoc = true,
  }) {
    this.singleDocName = singleDocName ?? id;
    App.instance.collections.add(this);
  }

  Future loadCollection();

  Future<void> loadDoc(SQDoc doc);
  Future updateDoc(SQDoc doc);
  Future createDoc(SQDoc doc);
  Future deleteDoc(String docId);

  bool doesDocExist(String docId);

  String getPath();
  String getANewDocId();

  SQDocField getFieldByName(String fieldName) =>
      fields.singleWhere((field) => field.name == fieldName);

  int get docsCount => docs.length;
}

abstract class SQUserCollection extends SQCollection {
  final String userId;

  SQUserCollection({
    required String id,
    required List<SQDocField> fields,
    required this.userId,
    String singleDocName = "User Doc",
  }) : super(id, fields, singleDocName: singleDocName);
}
