import '../../ui/text_field.dart';
import '../sq_field.dart';

class SQDoubleField extends SQField<double> {
  SQDoubleField(super.name, {super.defaultValue, super.editable});

  @override
  double? parse(source) {
    if (source is int) return source.toDouble();
    return super.parse(source);
  }

  @override
  formField(docScreen) => _SQDoubleFormField(this, docScreen);
}

class _SQDoubleFormField extends SQFormField<double, SQDoubleField> {
  const _SQDoubleFormField(super.field, super.docScreen);

  @override
  fieldBuilder(context) =>
      SQTextField(this, textParse: double.tryParse, numeric: true);
}
