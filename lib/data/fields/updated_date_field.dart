import '../sq_doc_field.dart';

class UpdatedDateField extends SQDocField<SQTimestamp> {
  UpdatedDateField(String name, {SQTimestamp? value})
      : super(name, value: value, readOnly: true);

  @override
  SQDocField<SQTimestamp> copy() => UpdatedDateField(name, value: value);

  @override
  collectField() => value = SQTimestamp.fromDate(DateTime.now());
}
