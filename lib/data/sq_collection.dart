import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/collection_screen.dart';

abstract class SQCollection {
  String id;
  List<SQDocField> fields;
  bool userData;
  List<SQDoc> docs = [];
  Function? refreshUI;
  CollectionScreen? screen;
  String singleDocName;

  SQCollection(this.id, this.fields,
      {this.userData = false, this.singleDocName = "Doc"});

  Future loadCollection();

  Future<SQDoc> loadDoc(SQDoc doc);
  Future updateDoc(SQDoc doc);
  Future createDoc(SQDoc doc);
  Future deleteDoc(String docId);

  String getPath();
  String getANewDocId();

  SQDocField getFieldByName(String fieldName) =>
      fields.singleWhere((field) => field.name == fieldName);
}
