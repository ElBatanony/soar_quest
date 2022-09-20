import '../db.dart';
import '../types.dart';
import '../../components/doc_form_field.dart';

class UpdatedDateField extends SQDocField<SQTimestamp> {
  UpdatedDateField(String name, {SQTimestamp? value})
      : super(name, value: value, readOnly: true);

  @override
  SQTimestamp parse(source) {
    return SQTimestamp.parse(source);
  }

  @override
  UpdatedDateField copy() => UpdatedDateField(name, value: value);

  @override
  collectField() => value = SQTimestamp.fromDate(DateTime.now());

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    throw UnimplementedError();
  }
}
