import 'package:soar_quest/app/app.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/collection_screen.dart';

class SQCollection {
  List<SQDocField> fields;
  String collectionPath;
  bool userData;
  List<SQDoc> docs = [];
  Function? updateUI;
  CollectionScreen? diplayScreen;

  SQCollection(this.fields, this.collectionPath, {this.userData = false}) {
    if (userData)
      collectionPath = App.instance.getAppPath() +
          "users/${App.instance.currentUser!.userId}/" +
          collectionPath;
    else
      collectionPath = App.instance.getAppPath() + collectionPath;
  }

  loadCollection() async {
    docs = [];
    print("fetching from $collectionPath");
    await db.collection(collectionPath).get().then((snap) {
      print('${snap.docs.length} docs fetched!');

      for (var doc in snap.docs) {
        var newDoc = SQDoc.withData(
            doc.id, fields, '$collectionPath/${doc.id}', doc.data(),
            userData: userData);
        newDoc.collection = this;
        docs.add(newDoc);
      }
    });
    if (updateUI != null) {
      updateUI!();
    }
  }

  Future createDoc(SQDoc doc) async {
    await db
        .doc("${doc.collection.collectionPath}/${doc.id}")
        .set(doc.collectFields());
    return loadCollection();
  }
}
