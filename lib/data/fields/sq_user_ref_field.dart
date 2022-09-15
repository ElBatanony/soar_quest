import 'package:soar_quest/app.dart';

import '../fields.dart';
import '../types.dart';

class SQUserRefField extends SQDocReferenceField {
  SQUserRefField(super.name, {super.value, super.readOnly})
      : super(collection: App.usersCollection);

  static SQDocReference get currentUserRef =>
      SQDocReference.fromDoc(App.auth.user.userDoc);

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
