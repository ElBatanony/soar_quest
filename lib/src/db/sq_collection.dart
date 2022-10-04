import '../../app.dart';
import 'sq_doc_field.dart';
import '../fields/sq_user_ref_field.dart';
import 'sq_doc.dart';
import '../../screens.dart';
import 'collection_filter.dart';
export 'collection_filter.dart';

abstract class SQCollection<DocType extends SQDoc> {
  final String id;
  List<SQDocField> fields;
  List<DocType> docs = [];
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
    App.registerCollection(this);
  }

  DocType constructDoc(String id) {
    return SQDoc(id, collection: this) as DocType;
  }

  Future loadCollection() async {
    initialized = true;
  }

  Future<void> loadDoc(DocType doc);
  Future saveDoc(DocType doc);
  Future createDoc(DocType doc);
  Future deleteDoc(String docId);

  bool doesDocExist(String docId);

  String getPath();
  String getANewDocId();

  SQDocField? getFieldByName(String fieldName) {
    if (!fields.any((field) => field.name == fieldName)) return null;
    return fields.singleWhere((field) => field.name == fieldName);
  }

  int get docsCount => docs.length;

  DocType newDoc({List<SQDocField> initialFields = const []}) {
    DocType newDoc = constructDoc(getANewDocId());

    for (var initialField in initialFields) {
      int index =
          newDoc.fields.indexWhere((field) => field.name == initialField.name);
      newDoc.fields[index] = initialField.copy();
    }

    for (var field in newDoc.fields)
      if (field.runtimeType == SQCreatedByField)
        field.value = SQUserRefField.currentUserRef;

    docs.add(newDoc);

    return newDoc;
  }

  List<DocType> filter(List<CollectionFilter> filters) {
    List<DocType> ret = docs;
    for (var filter in filters) {
      ret = filter.filter(ret) as List<DocType>;
    }
    return ret;
  }
}
