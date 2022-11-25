import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

import '../sq_app.dart';
import '../sq_auth.dart';
import 'fields/sq_user_ref_field.dart';
import 'sq_action.dart';
import 'sq_doc.dart';
import 'sq_updates.dart';

export 'collections/collection_filter.dart';
export 'sq_doc.dart';
export 'sq_updates.dart';

abstract class SQCollection<DocType extends SQDoc> {
  final String id;
  final SQDoc? parentDoc;

  final List<SQField<dynamic>> fields;
  final List<SQAction> actions;

  final String path;
  final SQUpdates updates;

  List<DocType> docs = [];

  static final List<SQCollection> _collections = [];

  SQCollection({
    required this.id,
    required this.fields,
    this.parentDoc,
    this.updates = const SQUpdates(),
    List<SQAction>? actions,
  })  : actions = actions ?? [],
        path = parentDoc == null
            ? "Example Apps/${SQApp.name}/$id"
            : "${parentDoc.path}/$id" {
    if (byPath(path) == null) _collections.add(this);

    if (updates.edits) this.actions.add(GoEditAction());
    if (updates.deletes) this.actions.add(DeleteDocAction(exitScreen: true));
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
    if (hasDoc(doc)) docs.removeWhere((d) => d.id == doc.id);
    return saveCollection();
  }

  String newDocId() => const Uuid().v1();

  F? getField<F extends SQField<dynamic>>(String fieldName) {
    return fields.singleWhereOrNull(
        (field) => field.name == fieldName && field is F) as F?;
  }

  DocType newDoc(
      {List<SQField<dynamic>> initialFields = const [], String? id}) {
    final newDoc = SQDoc(id ?? newDocId(), collection: this) as DocType;

    for (final initialField in initialFields) {
      final index =
          newDoc.fields.indexWhere((field) => field.name == initialField.name);
      newDoc.fields[index] = initialField.copy();
    }

    if (SQAuth.isSignedIn)
      fields
          .whereType<SQCreatedByField>()
          .forEach((field) => field.value = SQAuth.userDoc!.ref);

    return newDoc;
  }

  static SQCollection? byPath(String path) =>
      _collections.singleWhereOrNull((collection) => collection.path == path);

  List<SQField<dynamic>> copyFields() =>
      fields.map((field) => field.copy()).toList();

  DocType? getDoc(String id) => docs.firstWhereOrNull((doc) => doc.id == id);
}
