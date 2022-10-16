import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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
  SQDoc? parentDoc;
  List<SQField<dynamic>> fields;
  List<DocType> docs = [];
  late String singleDocName, path;
  bool readOnly, canDeleteDoc, initialized = false;
  DocScreenBuilder docScreen;
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

    path = parentDoc == null
        ? "Example Apps/${SQApp.name}/$id"
        : "${parentDoc!.path}/$id";

    if (byPath(path) == null) _collections.add(this);
  }

  bool hasDoc(DocType doc) => docs.any((d) => d.id == doc.id);

  @protected
  DocType constructDoc(String id) => SQDoc(id, collection: this) as DocType;

  Future<void> loadCollection();
  Future<void> saveCollection();

  Future<void> saveDoc(DocType doc) {
    if (hasDoc(doc)) docs.removeWhere((d) => d.id == doc.id);
    docs.add(doc);
    return saveCollection();
  }

  Future<void> deleteDoc(DocType doc) {
    if (hasDoc(doc)) deleteDoc(doc);
    return saveCollection();
  }

  Future<void> ensureInitialized(DocType doc) async {
    if (doc.initialized) return;
    throw "Doc not initialized";
  }

  String newDocId() => Uuid().v1();

  F? getField<F extends SQField<dynamic>>(String fieldName) {
    return fields.singleWhereOrNull(
        (field) => field.name == fieldName && field is F) as F?;
  }

  DocType newDoc({List<SQField<dynamic>> initialFields = const []}) {
    DocType newDoc = constructDoc(newDocId());

    for (final initialField in initialFields) {
      int index =
          newDoc.fields.indexWhere((field) => field.name == initialField.name);
      newDoc.fields[index] = initialField.copy();
    }

    fields
        .whereType<SQCreatedByField>()
        .forEach((field) => field.value = SQUserRefField.currentUserRef);

    newDoc.initialized = true;
    docs.add(newDoc);
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
}
