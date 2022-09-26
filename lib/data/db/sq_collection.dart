import '../../app.dart';
import 'sq_doc.dart';
import '../../screens/collection_screen.dart';

abstract class SQCollection {
  final String id;
  List<SQDocField> fields;
  List<SQDoc> docs = [];
  late String singleDocName;
  SQDoc? parentDoc;
  bool readOnly;
  bool canDeleteDoc;
  DocScreenBuilder docScreen;
  bool initialized = false;

  SQCollection(
    this.id,
    this.fields, {
    String? singleDocName,
    this.parentDoc,
    this.readOnly = false,
    this.canDeleteDoc = true,
    this.docScreen = defaultDocScreen,
  }) {
    this.singleDocName = singleDocName ?? id;
    App.collections.add(this);
  }

  Future loadCollection() async {
    initialized = true;
  }

  Future<void> loadDoc(SQDoc doc);
  Future updateDoc(SQDoc doc);
  Future createDoc(SQDoc doc);
  Future deleteDoc(String docId);

  bool doesDocExist(String docId);

  String getPath();
  String getANewDocId();

  SQDocField? getFieldByName(String fieldName) {
    if (!fields.any((field) => field.name == fieldName)) return null;
    return fields.singleWhere((field) => field.name == fieldName);
  }

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
