import '../../data.dart';

class SQTimestampField extends SQDocField<SQTimestamp> {
  SQTimestampField(String name, {SQTimestamp? value, super.readOnly})
      : super(name, value: value ?? SQTimestamp.fromDate(DateTime.now()));

  @override
  SQTimestampField copy() =>
      SQTimestampField(name, value: value, readOnly: readOnly);
}
