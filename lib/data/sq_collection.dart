import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soar_quest/app/app.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/collection_screen.dart';

SQCollection userCollection =
    SQCollection("users/${App.instance.currentUser!.userId}/data", []);

class SQCollection {
  String id;
  List<SQDocField> fields;
  bool userData;
  List<SQDoc> docs = [];
  Function? refreshUI;
  CollectionScreen? screen;
  String singleDocName;
  late CollectionReference ref;

  SQCollection(this.id, this.fields,
      {this.userData = false, this.singleDocName = "Doc"}) {
    ref = db.collection(getPath());
  }

  loadCollection() async {
    print("fetching from ${getPath()}");
    await db.collection(getPath()).get().then((snap) {
      docs = [];
      print('${snap.docs.length} docs fetched for $id!');

      for (var doc in snap.docs) {
        var newDoc = SQDoc(doc.id, fields, collection: this);
        newDoc.setData(doc.data());
        docs.add(newDoc);
      }
    });

    if (refreshUI != null) refreshUI!();
  }

  Future createDoc(SQDoc doc) async {
    await db.doc("${getPath()}/${doc.id}").set(doc.collectFields());
    return loadCollection();
  }

  Future deleteDoc(String docId) async {
    docs.removeWhere((doc) => doc.id == docId);
    await db.collection(getPath()).doc(docId).delete();
    return loadCollection();
  }

  String getPath() {
    if (userData)
      return App.instance.getAppPath() +
          "users/${App.instance.currentUser!.userId}/" +
          id;
    else
      return App.instance.getAppPath() + id;
  }
}
