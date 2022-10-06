import '../sq_doc.dart';

class SQVirtualField<T> extends SQField<T> {
  SQField<T> field;
  T Function(SQDoc doc) valueBuilder;

  SQVirtualField({required this.field, required this.valueBuilder})
      : super(field.name, readOnly: true);

  @override
  T? parse(source) => null;

  @override
  SQVirtualField<T> copy() =>
      SQVirtualField<T>(field: field, valueBuilder: valueBuilder);

  @override
  formField({Function? onChanged, SQDoc? doc}) {
    field.value = valueBuilder(doc!);
    field.readOnly = true;
    return field.formField();
  }
}
