import '../sq_doc.dart';

class SQVirtualField<T> extends SQField<T> {
  SQField<T> field;
  T Function(SQDoc doc) valueBuilder;

  // TODO: add show check that not FormScreen, FormScreenState<FormScreen>

  SQVirtualField({required this.field, required this.valueBuilder})
      : super(field.name, editable: false);

  @override
  T? parse(source) => null;

  @override
  SQVirtualField<T> copy() =>
      SQVirtualField<T>(field: field, valueBuilder: valueBuilder);

  @override
  formField({Function? onChanged, SQDoc? doc}) {
    SQField<T> fieldCopy = field.copy();
    fieldCopy.value = valueBuilder(doc!);
    fieldCopy.editable = false;
    return fieldCopy.formField();
  }
}
