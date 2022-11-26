import '../sq_action.dart';
import '../sq_collection.dart';

export '../sq_collection.dart';

class CollectionSlice implements SQCollection {
  CollectionSlice(
    this.collection, {
    this.filter,
    this.sliceFields,
    this.sliceActions,
    SQUpdates updates = const SQUpdates(),
  }) {
    this.updates = updates & collection.updates;
  }

  final SQCollection collection;

  final CollectionFilter? filter;
  final List<String>? sliceFields;
  final List<String>? sliceActions;

  @override
  late SQUpdates updates;

  @override
  List<SQAction> get actions => sliceActions == null
      ? collection.actions
      : collection.actions
          .where((action) => sliceActions!.contains(action.name))
          .toList();

  @override
  List<SQDoc> get docs =>
      filter == null ? collection.docs : filter!.filter(collection.docs);

  @override
  set docs(_) => throw UnimplementedError();

  @override
  bool hasDoc(SQDoc doc) => docs.any((d) => d.id == doc.id);

  // TODO: fix sliceFields usage in DocScreen (hide some fields)
  @override
  List<SQField<dynamic>> get fields => sliceFields == null
      ? collection.fields
      : collection.fields
          .where((field) => sliceFields!.contains(field.name))
          .toList();

  @override
  F? getField<F extends SQField<dynamic>>(String fieldName) {
    final field = collection.getField(fieldName) as F?;
    if (sliceFields == null) return field;
    if (field == null) return null;
    if (sliceFields!.contains(field.name) == false) return null;
    return field;
  }

  @override
  String get path => collection.path;

  @override
  bool get isLive => collection.isLive;

  ////////////////////////////////////////////////

  @override
  Future<void> deleteDoc(SQDoc doc) => collection.deleteDoc(doc);

  @override
  SQDoc? get parentDoc => collection.parentDoc;

  @override
  String get id => collection.id;

  @override
  Future<void> loadCollection() => collection.loadCollection();

  @override
  SQDoc newDoc({List<SQField<dynamic>> initialFields = const [], String? id}) =>
      collection.newDoc(initialFields: initialFields, id: id);

  @override
  String newDocId() => collection.newDocId();

  @override
  Future<void> saveCollection() => collection.saveCollection();

  @override
  Future<void> saveDoc(SQDoc doc) => collection.saveDoc(doc);

  @override
  List<SQField<dynamic>> copyFields() => collection.copyFields();

  @override
  SQDoc? getDoc(String id) => collection.getDoc(id);

  @override
  Stream<DocData> liveUpdates(SQDoc doc) => collection.liveUpdates(doc);
}
