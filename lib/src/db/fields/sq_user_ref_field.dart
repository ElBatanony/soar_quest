import '../../sq_app.dart';
import 'sq_ref_field.dart';

class SQUserRefField extends SQRefField {
  SQUserRefField(super.name, {super.value, super.readOnly})
      : super(collection: SQApp.usersCollection);

  static SQRef get currentUserRef => SQRef.fromDoc(SQApp.auth.user.userDoc);

  @override
  SQUserRefField copy() =>
      SQUserRefField(name, value: value, readOnly: readOnly);
}

class SQEditedByField extends SQUserRefField {
  SQEditedByField(super.name, {super.value}) : super(readOnly: true);

  @override
  SQEditedByField copy() => SQEditedByField(name, value: value);

  @override
  serialize() {
    value ??= SQUserRefField.currentUserRef;
    return super.serialize();
  }
}

class SQCreatedByField extends SQUserRefField {
  SQCreatedByField(super.name, {super.value}) : super(readOnly: true);

  @override
  SQCreatedByField copy() => SQCreatedByField(name, value: value);
}
