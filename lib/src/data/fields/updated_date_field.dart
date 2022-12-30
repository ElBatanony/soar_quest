import 'timestamp_field.dart';

class SQUpdatedDateField extends SQTimestampField {
  SQUpdatedDateField(super.name) {
    editable = false;
  }
}
