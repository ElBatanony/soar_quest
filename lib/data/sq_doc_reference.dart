import '../app/app.dart';
import '../data.dart';

class SQDocReference {
  SQDoc? doc;
  SQCollection collection;

  SQDocReference({required this.collection, this.doc});

  @override
  String toString() {
    return "${collection.id}/${doc?.identifier ?? "null"}";
  }

  static SQDocReference parse(dynamic source) {
    String docId = source["docId"];
    String collectionPath = source["collectionPath"];
    SQCollection collection = App.instance.collections
        .firstWhere((collection) => collection.getPath() == collectionPath);
    SQDoc doc = SQDoc(docId, collection.fields, collection: collection);
    if (docId != "") doc.loadDoc();
    return SQDocReference(doc: doc, collection: collection);
  }
}
