import '../../sq_auth.dart';
import 'sq_ref_field.dart';

class SQUserRefField extends SQRefField {
  SQUserRefField(super.name, {super.value, super.editable})
      : super(collection: SQAuth.usersCollection);

  @override
  SQUserRefField copy() =>
      SQUserRefField(name, value: value, editable: editable);
}

class SQEditedByField extends SQUserRefField {
  SQEditedByField(super.name, {super.value}) : super(editable: false);

  @override
  SQEditedByField copy() => SQEditedByField(name, value: value);

  @override
  serialize() {
    value ??= SQAuth.isSignedIn ? SQAuth.userDoc!.ref : null;
    return super.serialize();
  }
}

class SQCreatedByField extends SQUserRefField {
  SQCreatedByField(super.name, {super.value}) : super(editable: false);

  @override
  SQCreatedByField copy() => SQCreatedByField(name, value: value);
}
