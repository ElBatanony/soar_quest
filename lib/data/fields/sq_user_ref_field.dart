import 'package:soar_quest/app.dart';
import 'package:soar_quest/data.dart';
import 'package:soar_quest/data/types/sq_doc_reference.dart';

class SQUserRefField extends SQDocReferenceField {
  SQUserRefField(super.name, {super.value, super.readOnly})
      : super(collection: App.usersCollection);

  @override
  SQUserRefField copy() =>
      SQUserRefField(name, value: value, readOnly: readOnly);
}

