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

  SQCollection(this.id, this.fields, {this.userData = false});

  loadCollection() async {
    docs = [];
    print("fetching from ${getPath()}");
    await db.collection(getPath()).get().then((snap) {
      print('${snap.docs.length} docs fetched for $id!');

      for (var doc in snap.docs) {
        var newDoc = SQDoc.withData(doc.id, fields, doc.data());
        newDoc.collection = this;
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
