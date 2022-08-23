import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soar_quest/app/app.dart';
import 'package:soar_quest/data/sq_collection.dart';
import 'package:soar_quest/data/sq_doc.dart';

final firestore = FirebaseFirestore.instance;

class FirestoreCollection extends SQCollection {
  late CollectionReference ref;

  FirestoreCollection(
      {required String id,
      required List<SQDocField> fields,
      bool userData = false,
      String singleDocName = "Doc"})
      : super(id, fields, userData: userData, singleDocName: singleDocName) {
    ref = firestore.collection(getPath());
  }

  @override
  Future loadCollection() async {
    print("Fetching collection from ${getPath()}");
    final snap = await firestore.collection(getPath()).get();
    docs = [];
    print('${snap.docs.length} docs fetched for $id!');

    for (var doc in snap.docs) {
      var newDoc = SQDoc(doc.id, fields, collection: this);
      newDoc.setData(doc.data());
      docs.add(newDoc);
    }
  }

  @override
  Future createDoc(SQDoc doc) async {
    await firestore.doc("${getPath()}/${doc.id}").set(doc.collectFields());
    return loadCollection();
  }

  @override
  Future deleteDoc(String docId) async {
    docs.removeWhere((doc) => doc.id == docId);
    await firestore.collection(getPath()).doc(docId).delete();
    return loadCollection();
  }

  @override
  String getPath() {
    if (userData)
      return App.instance.getAppPath() +
          "users/${App.instance.currentUser.userId}/" +
          id;
    else
      return App.instance.getAppPath() + id;
  }

  DocumentReference getANewDocRef() => ref.doc();

  @override
  String getANewDocId() => getANewDocRef().id;

  // loadData() async {
  // await db.doc(getPath()).get().then((doc) {
  //   print(doc.data());
  //   setData(doc.data()!);
  // });
  // }

  @override
  Future<SQDoc> loadDoc(SQDoc doc) async {
    // SQDoc ret = SQDoc(id, newFields, collection: collection)
    await ref.doc(doc.id).get().then((docSnap) {
      doc.setData(docSnap.data() as Map<String, dynamic>);
    });
    return doc;
  }

  @override
  Future updateDoc(SQDoc doc) async {
    await firestore
        .doc("${getPath()}/${doc.id}")
        .set(doc.collectFields(), SetOptions(merge: true));
    return loadCollection();
  }

  // updateDoc() {
  //   return db.doc(getPath()).update(collectFields());
  // }
}
