import '../../sq_collection.dart';

class SQRef {
  String docId;
  String label;
  String collectionPath;

  SQRef({
    required this.collectionPath,
    required this.docId,
    required this.label,
  });

  SQRef.fromDoc(SQDoc doc)
      : this(
            collectionPath: doc.collection.path,
            docId: doc.id,
            label: doc.label);

  @override
  String toString() => label;

  static SQRef? parse(Map<String, dynamic> source) {
    String? docId = source["docId"];
    String? collectionPath = source["collectionPath"];
    String? label = source["label"];

    if (docId == null || collectionPath == null || label == null) return null;

    return SQRef(
      docId: docId,
      label: label,
      collectionPath: collectionPath,
    );
  }

  SQDoc getDoc() {
    return SQDoc(docId, collection: SQCollection.byPath(collectionPath)!);
  }
}
