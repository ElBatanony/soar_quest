import '../../app.dart';
import '../db.dart';
import '../types.dart';

class SQDocRefField extends SQDocField<SQDocRef> {
  SQCollection? _collection;
  late String collectionId;

  // TODO: use collection path. does not work for subcollections
  // both have same IDs but differnet parent docs
  SQCollection get collection =>
      _collection ?? App.getCollectionById(collectionId);

  SQDocRefField(super.name,
      {SQCollection? collection,
      String? collectionId,
      super.value,
      super.readOnly})
      : assert(collectionId != null || collection != null) {
    // TODO: remove the collection param
    _collection = collection;
    this.collectionId = collectionId ?? collection!.id;
  }

  @override
  Type get type => SQDocRef;

  @override
  SQDocRefField copy() {
    return SQDocRefField(name,
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

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    return SQDocRefFormField(this, onChanged: onChanged);
  }
}
