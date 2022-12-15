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
  formField(docScreenState) => _SQDoubleFormField(this, docScreenState);
}

class _SQDoubleFormField extends SQFormField<double, SQDoubleField> {
  const _SQDoubleFormField(super.field, super.docScreenState);

  @override
  fieldBuilder(context) => SQTextField(this, textParse: double.tryParse);
}
