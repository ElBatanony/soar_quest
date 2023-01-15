import '../data/sq_doc.dart';

class SQVirtualField<T> extends SQField<T> {
  SQVirtualField(this.subfield, this.valueBuilder) : super(subfield.name) {
    show = inFormScreen.not;
    editable = false;
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
