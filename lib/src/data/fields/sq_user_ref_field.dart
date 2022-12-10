import '../../sq_auth.dart';
import 'sq_ref_field.dart';

class SQUserRefField extends SQRefField {
  SQUserRefField(super.name, {super.defaultValue, super.editable, super.show})
      : super(collection: SQAuth.usersCollection);
}
