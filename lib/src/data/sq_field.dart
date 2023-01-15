import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/doc_screen.dart';
import '../screens/form_screen.dart';
import 'sq_doc.dart';

abstract class SQField<T> {
  SQField(this.name);

  String name = '';
  T? defaultValue;
  bool editable = true;
  bool require = false;
  DocCond show = trueCond;
  bool isInline = false;
  bool isLive = false;

  void init(SQDoc doc) => doc.setValue(name, defaultValue);

  dynamic serialize(T? value) => value;

  @mustCallSuper
  T? parse(dynamic source) {
    if (source is T) return source;
    return null;
  }

  SQFormField<T, SQField<T>> formField(DocScreen docScreen);

  @override
  String toString() => '$T $name';

  Widget valueDisplay(T? value) => Text(value.toString());
}

abstract class SQFormField<T, Field extends SQField<T>>
    extends StatelessWidget {
  const SQFormField(this.field, this.docScreen);

  final Field field;
  final DocScreen docScreen;
  SQDoc get doc => docScreen.doc;

  bool get isInFormScreen => docScreen is FormScreen;

  String get fieldLabelText => field.name + (field.require ? ' *' : '');

  T? getDocValue() => doc.getValue<T>(field.name);

  void setDocValue(T? value) {
    doc.setValue(field.name, value);
    if (isInFormScreen) {
      (docScreen as FormScreen).onFieldsChanged(field);
    }
    docScreen.refresh();
  }

  void clearDocValue() => setDocValue(field.defaultValue);

  Widget fieldLabel(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        fieldLabelText,
        style: Theme.of(context).textTheme.headline6,
      ));

  Widget readOnlyBuilder(BuildContext context) {
    final value = getDocValue();
    final valueString = value.toString();
    return GestureDetector(
      onLongPress: () async {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(milliseconds: 500),
            content: Text('Copied field: $valueString')));
        await Clipboard.setData(ClipboardData(text: valueString));
      },
      child: field.valueDisplay(value),
    );
  }

  Widget fieldBuilder(BuildContext context);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (field.isInline == false) fieldLabel(context),
            if (field.editable && isInFormScreen)
              fieldBuilder(context)
            else
              readOnlyBuilder(context),
          ],
        ),
      );
}
