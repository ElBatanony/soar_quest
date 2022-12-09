import '../sq_doc.dart';
import '../types/sq_timestamp.dart';

class SQUpdatedDateField extends SQField<SQTimestamp> {
  SQUpdatedDateField(super.name, {super.defaultValue}) : super(editable: false);

  @override
  SQTimestamp? parse(source) => SQTimestamp.parse(source);

  // TODO: set SQUpdatedDateField in FormScreen

  @override
  formField(docScreenState) {
    throw UnimplementedError();
  }
}
