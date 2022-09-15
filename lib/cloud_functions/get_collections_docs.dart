import 'package:soar_quest/data/db.dart';

import 'cloud_function.dart';

class GetCollectionDocs extends CloudFunction {
  SQCollection collection;

  GetCollectionDocs(this.collection) : super("getCollectionDocs");

  Future<List<SQDoc>> getDocs({String? collectionPath}) async {
    collectionPath ??= collection.getPath();

    dynamic json = await super.call(params: "collectionId=$collectionPath");

    List<dynamic> docs = json["docs"];
    List<SQDoc> sqDocs = [];

    for (var doc in docs) {
      SQDoc sqdoc = SQDoc(doc["id"], collection: collection);
      sqdoc.setData(doc["data"]);
      sqDocs.add(sqdoc);
    }

    return sqDocs;
  }
}
