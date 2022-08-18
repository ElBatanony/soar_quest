import 'package:soar_quest/data.dart';

import 'cloud_function.dart';

class GetCollectionDocs extends CloudFunction {
  SQCollection collection;

  GetCollectionDocs(this.collection) : super("getCollectionDocs");

  Future<List<SQDoc>> getDocs(String collectionId) async {
    dynamic json = await super.call(params: "collectionId=$collectionId");

    List<dynamic> docs = json["docs"];
    List<SQDoc> sqDocs = [];

    for (var doc in docs) {
      SQDoc sqdoc = SQDoc(doc["id"], collection.fields, collection: collection);
      sqdoc.setData(doc["data"]);
      sqDocs.add(sqdoc);
    }

    return sqDocs;
  }
}
