import '../screens/collection_screen.dart';
import 'sq_action.dart';
import 'sq_collection.dart';

class CollectionSlice implements SQCollection {
  final SQCollection collection;

  final CollectionFilter? filter;
  final List<String>? sliceFields;
  final List<String>? sliceActions;

  @override
  bool updates, adds, deletes, readOnly;

  CollectionSlice(this.collection,
      {this.updates = true,
      this.adds = true,
      this.deletes = true,
      this.readOnly = false,
      this.filter,
      this.sliceFields,
      this.sliceActions}) {
    if (readOnly) updates = adds = deletes = false;
  }

  @override
  List<SQAction> get actions => sliceActions == null
      ? collection.actions
      : collection.actions
          .where((action) => sliceActions!.contains(action.name))
          .toList();

  @override
  List<SQDoc> get docs =>
      filter == null ? collection.docs : collection.filterBy([filter!]);
  @override
  set docs(_) => throw UnimplementedError();

  @override
  bool hasDoc(SQDoc doc) => docs.any((d) => d.id == doc.id);

  @override
  List<SQField<dynamic>> get fields => sliceFields == null
      ? collection.fields
      : collection.fields
          .where((field) => sliceFields!.contains(field.name))
          .toList();

  @override
  F? getField<F extends SQField<dynamic>>(String fieldName) {
    F? field = collection.getField(fieldName);
    if (sliceFields == null) return field;
    if (field == null) return null;
    if (sliceFields!.contains(field.name) == false) return null;
    return field;
  }

  @override
  bool get initialized => collection.initialized;
  @override
  set initialized(_) => throw UnimplementedError();

  @override
  String get path => collection.path;
  @override
  set path(_) => throw UnimplementedError();

  ////////////////////////////////////////////////

  @override
  Future<void> deleteDoc(SQDoc doc) => collection.deleteDoc(doc);

  @override
  Future<void> ensureInitialized(SQDoc doc) =>
      collection.ensureInitialized(doc);

  @override
  List<SQDoc> filterBy(List<CollectionFilter> filters) =>
      collection.filterBy(filters);

  @override
  SQDoc? get parentDoc => collection.parentDoc;

  @override
  DocScreenBuilder get docScreen => collection.docScreen;

  @override
  String get id => collection.id;

  @override
  Future<void> loadCollection() => collection.loadCollection();

  @override
  SQDoc newDoc({List<SQField<dynamic>> initialFields = const []}) =>
      collection.newDoc(initialFields: initialFields);

  @override
  String newDocId() => collection.newDocId();

  @override
  Future<void> saveCollection() => collection.saveCollection();

  @override
  Future<void> saveDoc(SQDoc doc) => collection.saveDoc(doc);
}
