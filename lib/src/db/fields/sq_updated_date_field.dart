import '../sq_doc.dart';
import 'types/sq_timestamp.dart';

class UpdatedDateField extends SQField<SQTimestamp> {
  UpdatedDateField(String name, {SQTimestamp? value})
      : super(name, value: value, editable: false);

  @override
  SQTimestamp? parse(source) {
    return SQTimestamp.parse(source);
  }

  @override
  UpdatedDateField copy() => UpdatedDateField(name, value: value);

  @override
  serialize() => value = SQTimestamp.now();

  @override
  formField(SQDoc doc, {Function? onChanged}) {
    throw UnimplementedError();
  }
}
