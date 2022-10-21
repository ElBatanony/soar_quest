import '../sq_doc.dart';
import '../conditions.dart';

class SQVirtualField<T> extends SQField<T> {
  SQField<T> field;
  T Function(SQDoc doc) valueBuilder;

  SQVirtualField(
      {required this.field,
      required this.valueBuilder,
      DocContextCondition show = trueContextCond})
      : super(field.name,
            editable: false,
            show: (doc, context) =>
                !inFormScreen(doc, context) && show(doc, context));

  @override
  T? parse(source) => null;

  @override
  SQVirtualField<T> copy() =>
      SQVirtualField<T>(field: field, valueBuilder: valueBuilder, show: show);

  @override
  formField({Function? onChanged, SQDoc? doc}) {
    SQField<T> fieldCopy = field.copy();
    fieldCopy.value = valueBuilder(doc!);
    fieldCopy.editable = false;
    return fieldCopy.formField();
  }
}
