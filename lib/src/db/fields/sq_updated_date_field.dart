import '../sq_doc.dart';
import 'types/sq_timestamp.dart';

class UpdatedDateField extends SQField<SQTimestamp> {
  UpdatedDateField(String name, {SQTimestamp? value})
      : super(name, value: value, readOnly: true);

  @override
  SQTimestamp? parse(source) {
    return SQTimestamp.parse(source);
  }

  @override
  UpdatedDateField copy() => UpdatedDateField(name, value: value);

  @override
  collectField() => value = SQTimestamp.fromDate(DateTime.now());

  @override
  formField({Function? onChanged, SQDoc? doc}) {
    throw UnimplementedError();
  }
}
