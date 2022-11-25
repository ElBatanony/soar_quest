import '../sq_doc.dart';
import 'types/sq_timestamp.dart';

class SQUpdatedDateField extends SQField<SQTimestamp> {
  SQUpdatedDateField(super.name, {super.value}) : super(editable: false);

  @override
  SQTimestamp? parse(source) {
    return SQTimestamp.parse(source);
  }

  @override
  SQUpdatedDateField copy() => SQUpdatedDateField(name, value: value);

  @override
  serialize() => value = SQTimestamp.now();

  @override
  formField(SQDoc doc, {Function? onChanged}) {
    throw UnimplementedError();
  }
}
