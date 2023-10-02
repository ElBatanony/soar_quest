import 'package:cloud_firestore/cloud_firestore.dart'
    show CollectionReference, FirebaseFirestore, SetOptions;

import '../data/sq_collection.dart';

class FirestoreCollection extends SQCollection {
  FirestoreCollection({
    required super.id,
    required super.fields,
    super.parentDoc,
    super.updates,
    super.actions,
    super.isLive,
  }) {
    ref = FirebaseFirestore.instance.collection(path);
  }

  late CollectionReference ref;

  @override
  Future<void> loadCollection() async {
    isLoading = true;
    final snap = await ref.get();
    docs = [];
    for (final snapDoc in snap.docs) {
      final docData = snapDoc.data() as Map<String, dynamic>?;
      docs.add(newDoc(id: snapDoc.id)..parse(docData ?? {}));
    }
    isLoading = false;
  }

  @override
  Future<void> deleteDoc(SQDoc doc) async {
    await ref.doc(doc.id).delete();
    return super.deleteDoc(doc);
  }

  @override
  String newDocId() => ref.doc().id;

  @override
  Future<void> saveDoc(SQDoc doc) async {
    await ref.doc(doc.id).set(doc.serialize(), SetOptions(merge: true));
    return super.saveDoc(doc);
  }

  @override
  Future<void> saveCollection() => loadCollection();

  @override
  Stream<DocData> liveUpdates(SQDoc doc) =>
      ref.doc(doc.id).snapshots().map((snapDoc) {
        final docData = snapDoc.data() as Map<String, dynamic>?;
        return docData ?? {};
      });
}
