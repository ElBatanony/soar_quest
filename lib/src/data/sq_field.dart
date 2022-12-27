import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/doc_screen.dart';
import '../screens/form_screen.dart';
import 'sq_doc.dart';

abstract class SQField<T> {
  SQField(
    this.name, {
    this.defaultValue,
    this.editable = true,
    this.require = false,
    this.show = trueCond,
  });

  String name = '';
  T? defaultValue;
  bool editable;
  bool require;
  DocCond show;
  bool isInline = false;

  void init(SQDoc doc) => doc.setValue(name, defaultValue);

  dynamic serialize(T? value) => value;

  @mustCallSuper
  T? parse(dynamic source) {
    if (source is T) return source;
    return null;
  }

  SQFormField<T, SQField<T>> formField(DocScreenState docScreenState);

  @override
  String toString() => '$T $name';

  Widget valueDisplay(T? value) => Text(value.toString());
}

abstract class SQFormField<T, Field extends SQField<T>>
    extends StatelessWidget {
  const SQFormField(this.field, this.docScreenState);

  final Field field;
  final DocScreenState docScreenState;
  SQDoc get doc => docScreenState.doc;

  bool get isInFormScreen => docScreenState is FormScreenState;

  String get fieldLabelText => field.name + (field.require ? ' *' : '');

  T? getDocValue() => doc.getValue<T>(field.name);

  void setDocValue(T? value) {
    doc.setValue(field.name, value);
    if (isInFormScreen) {
      final formScreenState = docScreenState as FormScreenState;
      formScreenState.formScreen.onFieldsChanged?.call(formScreenState, this);
    }
    docScreenState.refreshScreen();
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
