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
    super.canDeleteDoc,
    super.docScreen,
  }) {
    ref = FirebaseFirestore.instance.collection(path);
  }

  @override
  Future loadCollection() async {
    print("Fetching collection from ${ref.path}");
    final snap = await ref.get();
    print('${snap.docs.length} docs fetched for $id!');
    docs = snap.docs
        .map((doc) => constructDoc(doc.id)
          ..parse(
            doc.data() as Map<String, dynamic>,
          ))
        .toList();
    super.loadCollection();
  }

  @override
  Future deleteDoc(DocType doc) async {
    await ref.doc(doc.id).delete();
    return loadCollection();
  }

  @override
  String getANewDocId() => ref.doc().id;

  @override
  Future loadDoc(DocType doc) async {
    if (doc.initialized) return;
    final docSnap = await ref.doc(doc.id).get();
    doc.parse((docSnap.data() ?? <String, dynamic>{}) as Map<String, dynamic>);
  }

  @override
  Future saveDoc(DocType doc) async {
    await ref.doc(doc.id).set(doc.serialize(), SetOptions(merge: true));
    return loadCollection();
  }
}
