import 'package:soar_quest/apps/app.dart';
import 'package:soar_quest/data_objects/data_object.dart';
import 'package:soar_quest/screens/collection_display_screen.dart';

class DataCollection {
  List<DataField> fields;
  String collectionPath;
  bool userData;
  List<DataObject> docs = [];
  Function? updateUI;
  CollectionDisplayScreen? diplayScreen;

  DataCollection(this.fields, this.collectionPath, {this.userData = false}) {
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
        var newDoc = DataObject.withData(
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
}
