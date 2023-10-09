import 'dart:async';

import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

import '../sq_app.dart';
import 'collections/filter_field.dart';
import 'sq_action.dart';
import 'sq_doc.dart';
import 'sq_updates.dart';

export 'collections/collection_filter.dart';
export 'collections/filter_field.dart';
export 'sq_doc.dart';
export 'sq_updates.dart';

abstract class SQCollection {
  SQCollection({
    required this.id,
    required this.fields,
    this.parentDoc,
    this.updates = const SQUpdates(),
    List<SQAction>? actions,
    this.isLive = false,
    this.filters = const [],
    this.onDocSaveCallback,
  })  : actions = actions ?? [],
        path = parentDoc == null
            ? 'Example Apps/${SQApp.name}/$id'
            : '${parentDoc.path}/$id' {
    if (byPath(path) == null) _collections.add(this);

    if (updates.edits) this.actions.add(GoEditAction());
    if (updates.deletes) this.actions.add(DeleteDocAction(exitScreen: true));
  }

  final String id;
  final SQDoc? parentDoc;

  final List<SQField<dynamic>> fields;
  final List<SQAction> actions;

  final String path;
  final SQUpdates updates;
  final bool isLive;

  List<CollectionFilterField<dynamic>> filters;

  List<SQDoc> docs = [];
  bool isLoading = false;

  static final List<SQCollection> _collections = [];

  FutureOr<void> Function(SQDoc doc)? onDocSaveCallback;

  bool hasDoc(SQDoc doc) => docs.any((d) => d.id == doc.id);

  Future<void> loadCollection();
  Future<void> saveCollection();

  Future<void> saveDoc(SQDoc doc) async {
    if (hasDoc(doc))
      docs[docs.indexWhere((d) => d.id == doc.id)] = doc;
    else
      docs.add(doc);
    await onDocSaveCallback?.call(doc);
    return saveCollection();
  }

  Future<void> deleteDoc(SQDoc doc) {
    if (hasDoc(doc)) docs.removeWhere((d) => d.id == doc.id);
    return saveCollection();
  }

  String newDocId() => const Uuid().v1();

  F? getField<F extends SQField<dynamic>>(String fieldName) =>
      fields.singleWhereOrNull((f) => f.name == fieldName && f is F) as F?;

  SQDoc newDoc({Map<String, dynamic> source = const {}, String? id}) =>
      SQDoc(id ?? newDocId(), collection: this)..parse(source);

  static SQCollection? byPath(String path) =>
      _collections.singleWhereOrNull((collection) => collection.path == path);

  SQDoc? getDoc(String id) => docs.firstWhereOrNull((doc) => doc.id == id);

  Stream<DocData> liveUpdates(SQDoc doc) => const Stream.empty();
}
