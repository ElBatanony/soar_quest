import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/collection_screen.dart';

import '../app/app.dart';

abstract class SQCollection {
  String id;
  List<SQDocField> fields;
  List<SQDoc> docs = [];
  CollectionScreen? screen;
  String singleDocName;
  SQDoc? parentDoc;

  SQCollection(
    this.id,
    this.fields, {
    this.singleDocName = "Doc",
    this.parentDoc,
  }) {
    App.instance.collections.add(this);
  }

  Future loadCollection();

  Future<void> loadDoc(SQDoc doc);
  Future updateDoc(SQDoc doc);
  Future createDoc(SQDoc doc);
  Future deleteDoc(String docId);

  Future<bool> doesDocExist(String docId);

  String getPath();
  String getANewDocId();

  SQDocField getFieldByName(String fieldName) =>
      fields.singleWhere((field) => field.name == fieldName);
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
