import 'package:collection/collection.dart';

import 'sq_action.dart';
import '../sq_app.dart';
import '../screens/collection_screen.dart';
import 'fields/sq_user_ref_field.dart';
import 'sq_doc.dart';
import 'collection_filter.dart';

export 'sq_doc.dart';
export 'collection_filter.dart';

abstract class SQCollection<DocType extends SQDoc> {
  final String id;
  List<SQField> fields;
  List<DocType> docs = [];
  late String singleDocName;
  SQDoc? parentDoc;
  bool readOnly;
  bool canDeleteDoc;
  DocScreenBuilder docScreen;
  bool initialized = false;
  late String path;
  List<SQAction> actions;

  static final List<SQCollection> _collections = [];

  SQCollection({
    required this.id,
    required this.fields,
    String? singleDocName,
    this.parentDoc,
    this.readOnly = false,
    this.canDeleteDoc = true,
    this.docScreen = defaultDocScreen,
    this.actions = const [],
  }) {
    this.singleDocName = singleDocName ?? id;

    if (parentDoc != null)
      path = "${parentDoc!.path}/$id";
    else
      path = "Example Apps/${SQApp.name}/$id";

    if (byPath(path) == null) _collections.add(this);
  }

  DocType constructDoc(String id) {
    return SQDoc(id, collection: this) as DocType;
  }

  Future loadCollection() async {
    initialized = true;
  }

  Future<void> loadDoc(DocType doc);
  Future saveDoc(DocType doc);
  Future deleteDoc(DocType doc);

  String getANewDocId();

  T? getField<T extends SQField>(String fieldName) {
    return fields
        .whereType<T>()
        .singleWhereOrNull((field) => field.name == fieldName);
  }

  int get docsCount => docs.length;

  DocType newDoc({List<SQField> initialFields = const []}) {
    DocType newDoc = constructDoc(getANewDocId());

    for (var initialField in initialFields) {
      int index =
          newDoc.fields.indexWhere((field) => field.name == initialField.name);
      newDoc.fields[index] = initialField.copy();
    }

    newDoc.initialized = true;

    for (var field in newDoc.fields)
      if (field.runtimeType == SQCreatedByField)
        field.value = SQUserRefField.currentUserRef;

    docs.add(newDoc);

    return newDoc;
  }

  List<DocType> filterBy(List<CollectionFilter> filters) {
    List<DocType> ret = docs;
    for (var filter in filters) {
      ret = filter.filter(ret) as List<DocType>;
    }
    return ret;
  }

  static SQCollection? byPath(String path) {
    return _collections
        .singleWhereOrNull((collection) => collection.path == path);
  }
}
