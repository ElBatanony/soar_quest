import '../sq_doc.dart';
import 'types/sq_timestamp.dart';

class SQUpdatedDateField extends SQField<SQTimestamp> {
  SQUpdatedDateField(String name, {SQTimestamp? value})
      : super(name, value: value, editable: false);

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
