import 'user_ref_field.dart';

class SQEditedByField extends SQUserRefField {
  SQEditedByField(super.name, {super.show}) : super(editable: false);
}
