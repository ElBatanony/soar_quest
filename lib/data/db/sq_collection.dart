import '../../app.dart';
import 'sq_doc.dart';

abstract class SQCollection {
  final String id;
  List<SQDocField> fields;
  List<SQDoc> docs = [];
  late String singleDocName;
  SQDoc? parentDoc;
  bool readOnly;
  bool canDeleteDoc;
  // TODO: add param for default docScreen, instead of setting for each CollectionScreen

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
