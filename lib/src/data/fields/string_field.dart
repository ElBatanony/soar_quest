import '../../ui/text_field.dart';
import '../sq_field.dart';

class SQStringField extends SQField<String> {
  SQStringField(super.name,
      {super.defaultValue,
      super.editable,
      super.require,
      super.show,
      this.maxLines = 1});

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
