import '../../sq_auth.dart';
import 'sq_ref_field.dart';

// TODO: separate user ref fields into separate files

class SQUserRefField extends SQRefField {
  SQUserRefField(super.name, {super.defaultValue, super.editable, super.show})
      : super(collection: SQAuth.usersCollection);
}

class SQEditedByField extends SQUserRefField {
  SQEditedByField(super.name, {super.show}) : super(editable: false);
}
