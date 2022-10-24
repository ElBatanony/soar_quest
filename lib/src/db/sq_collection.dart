import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

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
  final SQDoc? parentDoc;
  final DocScreenBuilder docScreen;

  final List<SQField<dynamic>> fields;
  final List<SQAction> actions;

  late final String path;
  late final bool updates, adds, deletes, readOnly;

  List<DocType> docs = [];
  bool initialized = false;

  static final List<SQCollection> _collections = [];

  SQCollection({
    required this.id,
    required this.fields,
    String? singleDocName,
    this.parentDoc,
    this.readOnly = false,
    this.updates = true,
    this.adds = true,
    this.deletes = true,
    this.docScreen = defaultDocScreen,
    List<SQAction>? actions,
  }) : actions = actions ?? [] {
    path = parentDoc == null
        ? "Example Apps/${SQApp.name}/$id"
        : "${parentDoc!.path}/$id";

    if (readOnly) updates = adds = deletes = false;

    if (byPath(path) == null) _collections.add(this);

    this.actions.addAll([GoEditAction(), DeleteDocAction(exitScreen: true)]);
  }

  bool hasDoc(DocType doc) => docs.any((d) => d.id == doc.id);

  Future<void> loadCollection();
  Future<void> saveCollection();

  Future<void> saveDoc(DocType doc) {
    if (hasDoc(doc))
      docs[docs.indexWhere((d) => d.id == doc.id)] = doc;
    else
      docs.add(doc);
    return saveCollection();
  }

  Future<void> deleteDoc(DocType doc) {
    if (hasDoc(doc)) deleteDoc(doc);
    return saveCollection();
  }

  String newDocId() => Uuid().v1();

  F? getField<F extends SQField<dynamic>>(String fieldName) {
    return fields.singleWhereOrNull(
        (field) => field.name == fieldName && field is F) as F?;
  }

  DocType newDoc(
      {List<SQField<dynamic>> initialFields = const [], String? id}) {
    DocType newDoc = SQDoc(id ?? newDocId(), collection: this) as DocType;

    for (final initialField in initialFields) {
      int index =
          newDoc.fields.indexWhere((field) => field.name == initialField.name);
      newDoc.fields[index] = initialField.copy();
    }

    fields
        .whereType<SQCreatedByField>()
        .forEach((field) => field.value = SQUserRefField.currentUserRef);

    return newDoc;
  }

  List<DocType> filterBy(List<CollectionFilter> filters) {
    return filters.fold(
        docs,
        (remainingDocs, filter) =>
            filter.filter(remainingDocs) as List<DocType>);
  }

  static SQCollection? byPath(String path) =>
      _collections.singleWhereOrNull((collection) => collection.path == path);

  List<SQField<dynamic>> copyFields() =>
      fields.map((field) => field.copy()).toList();

  SQDoc? getDoc(String id) => docs.firstWhereOrNull((doc) => doc.id == id);
}
