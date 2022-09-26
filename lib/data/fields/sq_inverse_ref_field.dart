import 'package:soar_quest/data/docs_filter.dart';

import '../../app.dart';
import '../db.dart';
import '../types.dart';

class SQInverseRefField extends SQListField {
  late String collectionId;
  String refFieldName;
  SQDoc? doc;

  SQCollection get collection => App.getCollectionById(collectionId);

  List<SQDocRef> inverseRefs(SQDoc doc) {
    return collection
        .filter([DocRefFilter(refFieldName, doc.ref)])
        .map((doc) => doc.ref)
        .toList();
  }

  SQInverseRefField(super.name,
      {required this.refFieldName, this.doc, String? collectionId})
      : super(readOnly: true) {
    this.collectionId = collectionId ?? name;
  }

  @override
  SQInverseRefField copy() {
    return SQInverseRefField(name,
        refFieldName: refFieldName, doc: doc, collectionId: collectionId);
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
