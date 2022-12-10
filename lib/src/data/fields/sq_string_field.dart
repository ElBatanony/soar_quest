import '../../ui/sq_text_field.dart';
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
  String? parse(source) {
    if (source is String) return source;
    return null;
  }

  @override
  formField(docScreenState) => _SQStringFormField(this, docScreenState);
}

class _SQStringFormField extends SQFormField<String, SQStringField> {
  const _SQStringFormField(super.field, super.docScreenState);

  @override
  fieldBuilder(context) =>
      SQTextField(this, textParse: (text) => text, maxLines: field.maxLines);
}
