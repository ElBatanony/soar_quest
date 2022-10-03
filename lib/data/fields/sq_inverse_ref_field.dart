import '../db.dart';
import '../types.dart';

class SQInverseRefField extends SQListField {
  SQCollection collection;
  String refFieldName;
  SQDoc? doc;

  Future<List<SQDocRef>> inverseRefs(SQDoc doc) async {
    if (!collection.initialized) await collection.loadCollection();

    return collection
        .filter([DocRefFilter(refFieldName, doc.ref)])
        .map((doc) => doc.ref)
        .toList();
  }

  SQInverseRefField(super.name,
      {required this.refFieldName, this.doc, required this.collection})
      : super(readOnly: true);

  @override
  SQInverseRefField copy() {
    return SQInverseRefField(
      name,
      refFieldName: refFieldName,
      doc: doc,
      collection: collection,
    );
  }

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    return InverseRefFormField(this, doc: doc);
  }

  @override
  DocFormField readOnlyField({SQDoc? doc}) {
    return InverseRefFormField(this, doc: doc);
  }
}
