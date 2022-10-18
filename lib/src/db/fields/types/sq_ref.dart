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
    String? docId = source["docId"] as String?;
    String? collectionPath = source["collectionPath"] as String?;
    String? label = source["label"] as String?;

    if (docId == null || collectionPath == null || label == null) return null;

    return SQRef(
      docId: docId,
      label: label,
      collectionPath: collectionPath,
    );
  }

  Future<SQDoc> doc() async {
    SQCollection? collection = SQCollection.byPath(collectionPath);
    if (collection == null) throw "Referencing a non-existing collection";
    SQDoc doc = collection.constructDoc(docId);
    await collection.ensureInitialized(doc);
    return doc;
  }

  @override
  bool operator ==(Object other) {
    if (other is! SQRef) return false;
    return other.docId == docId && other.collectionPath == collectionPath;
  }

  @override
  int get hashCode => docId.hashCode ^ collectionPath.hashCode;
}
