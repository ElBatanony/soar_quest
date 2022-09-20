import '../db.dart';
import '../types.dart';

class SQTimestampField extends SQDocField<SQTimestamp> {
  SQTimestampField(String name, {SQTimestamp? value, super.readOnly})
      : super(name, value: value ?? SQTimestamp.fromDate(DateTime.now()));

  @override
  SQTimestamp parse(source) {
    return SQTimestamp.parse(source);
  }

  @override
  SQTimestampField copy() =>
      SQTimestampField(name, value: value, readOnly: readOnly);

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    return SQTimeOfDayFormField(this, onChanged: onChanged);
  }
}
