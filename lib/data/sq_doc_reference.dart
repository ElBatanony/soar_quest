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

class SQDocReferenceField extends SQDocField<SQDocReference> {
  SQDocReferenceField(String name, {required SQDocReference value})
      : super(name, value: value);

  @override
  Type get type => SQDocReference;

  @override
  SQDocField copy() {
    return SQDocReferenceField(name, value: value);
  }

  @override
  Map<String, dynamic> collectField() {
    return {
      "docId": value.doc?.id ?? "",
      "collectionPath": value.collection.getPath()
    };
  }
}
