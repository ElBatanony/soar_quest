import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soar_quest/app.dart';
import 'package:soar_quest/data/db/sq_collection.dart';
import 'package:soar_quest/data/db/sq_doc.dart';

final firestore = FirebaseFirestore.instance;

class FirestoreCollection extends SQCollection {
  late CollectionReference ref;

  FirestoreCollection({
    required String id,
    required List<SQDocField> fields,
    String singleDocName = "Doc",
    super.parentDoc,
    super.readOnly,
    super.canDeleteDoc,
  }) : super(id, fields, singleDocName: singleDocName) {
    ref = firestore.collection(getPath());
  }

  @override
  Future loadCollection() async {
    print("Fetching collection from ${ref.path}");
    final snap = await ref.get();
    print('${snap.docs.length} docs fetched for $id!');
    docs = snap.docs
        .map((doc) => SQDoc(doc.id, collection: this)
          ..setData(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future createDoc(SQDoc doc) async {
    docs.add(doc);
    await firestore.doc("${getPath()}/${doc.id}").set(doc.collectFields());
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
  String getPath() {
    if (parentDoc != null) return "${parentDoc!.getPath()}/$id";
    return App.instance.getAppPath() + id;
  }

  DocumentReference getANewDocRef() => ref.doc();

  @override
  String getANewDocId() => getANewDocRef().id;

  @override
  Future loadDoc(SQDoc doc) async {
    final docSnap = await ref.doc(doc.id).get();
    doc.setData(
        (docSnap.data() ?? <String, dynamic>{}) as Map<String, dynamic>);
  }

  @override
  Future updateDoc(SQDoc doc) async {
    await firestore
        .doc("${getPath()}/${doc.id}")
        .set(doc.collectFields(), SetOptions(merge: true));
    return loadCollection();
  }
}

class FirestoreUserCollection extends FirestoreCollection
    implements SQUserCollection {
  @override
  final String userId;

  FirestoreUserCollection({
    required super.id,
    required this.userId,
    required super.fields,
    super.singleDocName,
  });

  @override
  String getPath() => App.instance.getAppPath() + "users/$userId/" + id;
}