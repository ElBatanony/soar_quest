import '../data/sq_doc.dart';
import '../ui/text_field.dart';

class SQIntField extends SQField<int> {
  SQIntField(super.name);

  @override
  formField(docScreen) => _SQIntFormField(this, docScreen);

  int sumDocs(List<SQDoc> docs) =>
      docs.fold(0, (sum, doc) => sum + (doc.getValue<int>(name) ?? 0));
}

class _SQIntFormField extends SQFormField<int, SQIntField> {
  const _SQIntFormField(super.field, super.docScreen);

  @override
  fieldBuilder(context) =>
      SQTextField(this, textParse: int.tryParse, numeric: true);
}
