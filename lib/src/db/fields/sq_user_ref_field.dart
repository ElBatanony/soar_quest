import '../../app/app.dart';
import 'sq_doc_ref_field.dart';

class SQUserRefField extends SQRefField {
  SQUserRefField(super.name, {super.value, super.readOnly})
      : super(collection: App.usersCollection);

  static SQRef get currentUserRef => SQRef.fromDoc(App.auth.user.userDoc);

  @override
  SQUserRefField copy() =>
      SQUserRefField(name, value: value, readOnly: readOnly);
}

class SQEditedByField extends SQUserRefField {
  SQEditedByField(super.name, {super.value}) : super(readOnly: true);

  @override
  SQEditedByField copy() => SQEditedByField(name, value: value);

  @override
  collectField() {
    value ??= SQUserRefField.currentUserRef;
    return super.collectField();
  }
}

class SQCreatedByField extends SQUserRefField {
  SQCreatedByField(super.name, {super.value}) : super(readOnly: true);

  @override
  SQCreatedByField copy() => SQCreatedByField(name, value: value);
}
