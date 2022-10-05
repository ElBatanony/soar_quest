import '../../sq_collection.dart';

class SQRef {
  String docId;
  String docIdentifier;
  String collectionPath;

  SQRef({
    required this.collectionPath,
    required this.docId,
    required this.docIdentifier,
  });

  SQRef.fromDoc(SQDoc doc)
      : this(
            collectionPath: doc.collection.getPath(),
            docId: doc.id,
            docIdentifier: doc.identifier);

  @override
  String toString() => docIdentifier;

  static SQRef? parse(Map<String, dynamic> source) {
    String? docId = source["docId"];
    String? collectionPath = source["collectionPath"];
    String? docIdentifier = source["docIdentifier"];

    if (docId == null || collectionPath == null || docIdentifier == null)
      return null;

    return SQRef(
      docId: docId,
      docIdentifier: docIdentifier,
      collectionPath: collectionPath,
    );
  }

  SQDoc getDoc() {
    return SQDoc(docId, collection: SQCollection.byPath(collectionPath)!);
  }
}
