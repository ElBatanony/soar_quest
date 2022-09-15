import '../../data.dart';

class SQTimestampField extends SQDocField<SQTimestamp> {
  SQTimestampField(String name, {SQTimestamp? value, super.readOnly})
      : super(name, value: value ?? SQTimestamp(0, 0));

  @override
  SQTimestampField copy() =>
      SQTimestampField(name, value: value, readOnly: readOnly);
}
