import '../../data.dart';

class SQDocReference {
  String docId;
  String docIdentifier;
  String collectionPath;

  SQDocReference({
    required this.collectionPath,
    required this.docId,
    required this.docIdentifier,
  });

  SQDocReference.fromDoc(SQDoc doc)
      : this(
            collectionPath: doc.collection.getPath(),
            docId: doc.id,
            docIdentifier: doc.identifier);

  @override
  String toString() => docIdentifier;

  static SQDocReference? parse(Map<String, dynamic> source) {
    String? docId = source["docId"];
    String? collectionPath = source["collectionPath"];
    String? docIdentifier = source["docIdentifier"];

    if (docId == null || collectionPath == null || docIdentifier == null)
      return null;

    return SQDocReference(
      docId: docId,
      docIdentifier: docIdentifier,
      collectionPath: collectionPath,
    );
  }
}
