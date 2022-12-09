import '../sq_doc.dart';

class SQVirtualField<T> extends SQField<T> {
  SQVirtualField(
      {required this.field,
      required this.valueBuilder,
      DocCond show = trueCond})
      : super(
          field.name,
          editable: false,
          show: inFormScreen.not & show,
        );

  SQField<T> field;
  T Function(SQDoc doc) valueBuilder;

  @override
  T? parse(source) => null;

  @override
  formField(docScreenState) {
    final retValue = valueBuilder(docScreenState.doc);
    docScreenState.doc.setValue(field.name, retValue);
    field
      ..editable = false
      ..isInline = false;
    // TODO: set editable and inline in constructor
    return field.formField(docScreenState);
  }
}
