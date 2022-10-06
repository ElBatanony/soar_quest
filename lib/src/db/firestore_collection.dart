import 'package:cloud_firestore/cloud_firestore.dart';

import 'sq_collection.dart';

final firestore = FirebaseFirestore.instance;

class FirestoreCollection<DocType extends SQDoc> extends SQCollection<DocType> {
  FirestoreCollection({
    required super.id,
    required super.fields,
    super.singleDocName,
    super.parentDoc,
    super.readOnly,
    super.canDeleteDoc,
    super.docScreen,
  });

  CollectionReference get ref => firestore.collection(path);

  @override
  Future loadCollection() async {
    print("Fetching collection from ${ref.path}");
    final snap = await ref.get();
    print('${snap.docs.length} docs fetched for $id!');
    docs = snap.docs
        .map((doc) => constructDoc(doc.id)
          ..setData(
            doc.data() as Map<String, dynamic>,
          ))
        .toList();
    super.loadCollection();
  }

  @override
  Future createDoc(DocType doc) async {
    docs.add(doc);
    await firestore.doc(doc.getPath()).set(doc.collectFields());
    return loadCollection();
  }

  @override
  Future deleteDoc(String docId) async {
    docs.removeWhere((doc) => doc.id == docId);
    await ref.doc(docId).delete();
    return loadCollection();
  }

  @override
  bool doesDocExist(String docId) {
    return docs.any((doc) => doc.id == docId);
  }

  @override
  String getANewDocId() => ref.doc().id;

  @override
  Future loadDoc(DocType doc) async {
    final docSnap = await ref.doc(doc.id).get();
    doc.setData(
        (docSnap.data() ?? <String, dynamic>{}) as Map<String, dynamic>);
  }

  @override
  Future saveDoc(DocType doc) async {
    await firestore
        .doc(doc.getPath())
        .set(doc.collectFields(), SetOptions(merge: true));
    return loadCollection();
  }
}
