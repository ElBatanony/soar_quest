import '../../app/app.dart';
import '../sq_doc_field.dart';

class SQEditedByField extends SQDocField<String> {
  SQEditedByField(String name, {String? userId})
      : super(name, value: userId, readOnly: true);

  @override
  SQDocField<String> copy() => SQEditedByField(name);

  @override
  collectField() => value = App.userId;
}
