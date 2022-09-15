import '../data.dart';
import 'types/sq_doc_reference.dart';

class SQDocReferenceField extends SQDocField<SQDocReference> {
  SQCollection collection;

  SQDocReferenceField(super.name,
      {required this.collection, super.value, super.readOnly});

  @override
  Type get type => SQDocReference;

  @override
  SQDocReferenceField copy() {
    return SQDocReferenceField(name,
        collection: collection, value: value, readOnly: readOnly);
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
