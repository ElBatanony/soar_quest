import '../../sq_auth.dart';
import 'ref_field.dart';

class SQUserRefField extends SQRefField {
  SQUserRefField(super.name, {super.defaultValue, super.editable})
      : super(collection: SQAuth.usersCollection);
}
