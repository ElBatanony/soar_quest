import '../sq_doc.dart';

class SQVirtualField<T> extends SQField<T> {
  SQField<T> field;
  T Function(SQDoc doc) valueBuilder;

  SQVirtualField(
      {required this.field,
      required this.valueBuilder,
      DocCond show = trueCond})
      : super(
          field.name,
          editable: false,
          show: inFormScreen.not & show,
        );

  @override
  T? parse(source) => null;

  @override
  SQVirtualField<T> copy() =>
      SQVirtualField<T>(field: field, valueBuilder: valueBuilder, show: show);

  @override
  formField(SQDoc doc, {VoidCallback? onChanged}) {
    value = valueBuilder(doc);
    final fieldCopy = field.copy()
      ..value = value
      ..editable = false
      ..isInline = isInline;
    return fieldCopy.formField(doc);
  }
}
