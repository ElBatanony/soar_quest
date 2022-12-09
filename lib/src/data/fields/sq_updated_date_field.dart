import '../sq_doc.dart';
import '../types/sq_timestamp.dart';

class SQUpdatedDateField extends SQField<SQTimestamp> {
  SQUpdatedDateField(super.name, {super.defaultValue}) : super(editable: false);

  @override
  SQTimestamp? parse(source) => SQTimestamp.parse(source);

  @override
  serialize() => value = SQTimestamp.now();

  @override
  formField(docScreenState) {
    throw UnimplementedError();
  }
}
