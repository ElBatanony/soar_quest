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
        .map((doc) => newDoc(id: doc.id)
          ..parse(
            doc.data() as Map<String, dynamic>,
          ))
        .toList();
  }

  @override
  Future<void> deleteDoc(DocType doc) async {
    await ref.doc(doc.id).delete();
    return super.deleteDoc(doc);
  }

  @override
  String newDocId() => ref.doc().id;

  @override
  Future<void> saveDoc(DocType doc) async {
    await ref.doc(doc.id).set(doc.serialize(), SetOptions(merge: true));
    return super.saveDoc(doc);
  }

  @override
  Future<void> saveCollection() => loadCollection();
}
