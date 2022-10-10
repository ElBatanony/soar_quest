import '../sq_collection.dart';
import 'sq_list_field.dart';
import 'sq_ref_field.dart';
import 'sq_virtual_field.dart';

class SQRefDocsField extends SQVirtualField<List<SQDoc>> {
  String refFieldName;
  SQCollection Function() refCollection;

  SQRefDocsField(String name,
      {required this.refCollection, required this.refFieldName})
      : super(
            field: SQListField(name),
            valueBuilder: (doc) => refCollection()
                .docs
                .where((refDoc) =>
                    refDoc.getField<SQRefField>(refFieldName).value == doc.ref)
                .toList());

  @override
  SQRefDocsField copy() => SQRefDocsField(name,
      refCollection: refCollection, refFieldName: refFieldName);
}
