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
        ) {
    subfield
      ..editable = false
      ..isInline = false;
  }

  SQField<T> subfield;
  T Function(SQDoc doc) valueBuilder;

  @override
  formField(docScreen) {
    final retValue = valueBuilder(docScreen.doc);
    docScreen.doc.setValue(subfield.name, retValue);
    return subfield.formField(docScreen);
  }
}
