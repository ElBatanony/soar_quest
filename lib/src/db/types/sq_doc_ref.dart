import '../../app/app.dart';
import '../sq_doc.dart';

class SQDocRef {
  String docId;
  String docIdentifier;
  String collectionPath;

  SQDocRef({
    required this.collectionPath,
    required this.docId,
    required this.docIdentifier,
  });

  SQDocRef.fromDoc(SQDoc doc)
      : this(
            collectionPath: doc.collection.getPath(),
            docId: doc.id,
            docIdentifier: doc.identifier);

  @override
  String toString() => docIdentifier;

  static SQDocRef? parse(Map<String, dynamic> source) {
    String? docId = source["docId"];
    String? collectionPath = source["collectionPath"];
    String? docIdentifier = source["docIdentifier"];

    if (docId == null || collectionPath == null || docIdentifier == null)
      return null;

    return SQDocRef(
      docId: docId,
      docIdentifier: docIdentifier,
      collectionPath: collectionPath,
    );
  }

  SQDoc getDoc() {
    return SQDoc(docId, collection: App.collectionByPath(collectionPath));
  }
}
