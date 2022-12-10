import '../../sq_auth.dart';
import '../types/sq_ref.dart';
import 'sq_user_ref_field.dart';

class SQCreatedByField extends SQUserRefField {
  SQCreatedByField(super.name, {super.defaultValue}) : super(editable: false);

  @override
  init(doc) {
    super.init(doc);
    if (SQAuth.isSignedIn && doc.getValue<SQRef>(name) == null)
      doc.setValue(name, SQAuth.userDoc!.ref);
  }
}
