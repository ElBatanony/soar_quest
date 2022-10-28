import '../sq_doc.dart';
import '../conditions.dart';

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
  formField(SQDoc doc, {Function? onChanged}) {
    value = valueBuilder(doc);
    SQField<T> fieldCopy = field.copy();
    fieldCopy.value = value;
    fieldCopy.editable = false;
    fieldCopy.isInline = isInline;
    return fieldCopy.formField(doc);
  }
}
