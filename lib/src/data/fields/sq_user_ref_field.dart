import '../../sq_auth.dart';
import 'sq_ref_field.dart';

// TODO: separate user ref fields into separate files

class SQUserRefField extends SQRefField {
  SQUserRefField(super.name, {super.defaultValue, super.editable, super.show})
      : super(collection: SQAuth.usersCollection);
}

class SQEditedByField extends SQUserRefField {
  SQEditedByField(super.name, {super.defaultValue, super.show})
      : super(editable: false);

  // TODO: set SQEditedByField in FormScreen
  // @override
  // serialize() {
  //   value ??= SQAuth.isSignedIn ? SQAuth.userDoc!.ref : null;
  //   return super.serialize();
  // }
}

class SQCreatedByField extends SQUserRefField {
  SQCreatedByField(super.name, {super.defaultValue}) : super(editable: false);

  @override
  init(doc) {
    super.init(doc);
    if (SQAuth.isSignedIn && doc.getValue<SQRef>(name) == null)
      doc.setValue(name, SQAuth.userDoc!.ref);
  }
}
