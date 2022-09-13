import '../../app/app.dart';
import '../sq_doc_field.dart';

class SQEditedByField extends SQDocField<String> {
  SQEditedByField(String name) : super(name, readOnly: true);

  @override
  SQDocField<String> copy() => SQEditedByField(name);

  @override
  collectField() => App.userId;
}
