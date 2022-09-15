import '../db.dart';
import '../types.dart';

class UpdatedDateField extends SQDocField<SQTimestamp> {
  UpdatedDateField(String name, {SQTimestamp? value})
      : super(name, value: value, readOnly: true);

  @override
  UpdatedDateField copy() => UpdatedDateField(name, value: value);

  @override
  collectField() => value = SQTimestamp.fromDate(DateTime.now());
}
