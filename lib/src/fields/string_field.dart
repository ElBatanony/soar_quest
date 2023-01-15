import '../data/sq_field.dart';
import '../ui/text_field.dart';

class SQStringField extends SQField<String> {
  SQStringField(super.name, {this.maxLines = 1});

  final int maxLines;

  @override
  formField(docScreen) => _SQStringFormField(this, docScreen);
}

class _SQStringFormField extends SQFormField<String, SQStringField> {
  const _SQStringFormField(super.field, super.docScreen);

  @override
  fieldBuilder(context) =>
      SQTextField(this, textParse: (text) => text, maxLines: field.maxLines);
}
