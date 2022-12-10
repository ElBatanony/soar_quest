import '../sq_doc.dart';

class SQVirtualField<T> extends SQField<T> {
  SQVirtualField(
      {required this.subfield,
      required this.valueBuilder,
      DocCond show = trueCond})
      : super(
          subfield.name,
          editable: false,
          show: inFormScreen.not & show,
        );

  SQField<T> subfield;
  T Function(SQDoc doc) valueBuilder;

  @override
  T? parse(source) => null;

  @override
  formField(docScreenState) {
    final retValue = valueBuilder(docScreenState.doc);
    docScreenState.doc.setValue(subfield.name, retValue);
    subfield
      ..editable = false
      ..isInline = false;
    // TODO: set editable and inline in constructor
    return subfield.formField(docScreenState);
  }
}
