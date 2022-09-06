import '../data.dart';

class SQDocReference {
  String docId;
  String docIdentifier;
  String collectionPath;

  SQDocReference({
    required this.collectionPath,
    required this.docId,
    required this.docIdentifier,
  });

  @override
  String toString() => docIdentifier;

  static SQDocReference? parse(dynamic source) {
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

class SQDocReferenceField extends SQDocField<SQDocReference> {
  SQCollection collection;

  SQDocReferenceField(super.name, {required this.collection, super.value});

  @override
  Type get type => SQDocReference;

  @override
  SQDocField<SQDocReference> copy() {
    return SQDocReferenceField(name, collection: collection, value: value);
  }

  @override
  Map<String, dynamic> collectField() {
    if (value == null) return {};

    return {
      "docId": value!.docId,
      "docIdentifier": value!.docIdentifier,
      "collectionPath": value!.collectionPath
    };
  }
}
