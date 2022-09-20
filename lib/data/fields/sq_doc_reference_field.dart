import '../db.dart';
import '../types.dart';

class SQDocReferenceField extends SQDocField<SQDocRef> {
  SQCollection collection;

  SQDocReferenceField(super.name,
      {required this.collection, super.value, super.readOnly});

  @override
  Type get type => SQDocRef;

  @override
  SQDocReferenceField copy() {
    return SQDocReferenceField(name,
        collection: collection, value: value, readOnly: readOnly);
  }

  @override
  SQDocRef? parse(source) {
    return SQDocRef.parse(source);
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
