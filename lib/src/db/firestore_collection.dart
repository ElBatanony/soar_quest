import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore, CollectionReference, SetOptions;

import 'sq_collection.dart';

class FirestoreCollection<DocType extends SQDoc> extends SQCollection<DocType> {
  late CollectionReference ref;

  FirestoreCollection({
    required super.id,
    required super.fields,
    super.singleDocName,
    super.parentDoc,
    super.readOnly,
    super.updates,
    super.adds,
    super.deletes,
    super.docScreen,
    super.actions,
  }) {
    ref = FirebaseFirestore.instance.collection(path);
  }

  @override
  Future<void> loadCollection() async {
    print("Fetching collection from ${ref.path}");
    final snap = await ref.get();
    print('${snap.docs.length} docs fetched for $id!');
    docs = snap.docs
        .map((doc) => constructDoc(doc.id)
          ..parse(
            doc.data() as Map<String, dynamic>,
          ))
        .toList();
    initialized = true;
  }

  @override
  Future<void> deleteDoc(DocType doc) async {
    await ref.doc(doc.id).delete();
    return loadCollection();
  }

  @override
  String newDocId() => ref.doc().id;

  @override
  Future<void> ensureInitialized(DocType doc) async {
    if (doc.initialized) return;
    final docSnap = await ref.doc(doc.id).get();
    doc.parse((docSnap.data() ?? <String, dynamic>{}) as Map<String, dynamic>);
  }

  @override
  Future<void> saveDoc(DocType doc) async {
    await ref.doc(doc.id).set(doc.serialize(), SetOptions(merge: true));
    return loadCollection();
  }

  @override
  Future<void> saveCollection() async => {};
}
