import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/doc_screen.dart';
import '../screens/form_screen.dart';
import 'sq_doc.dart';

export 'package:flutter/material.dart' show VoidCallback;

abstract class SQField<T> {
  SQField(
    this.name, {
    this.value,
    this.editable = true,
    this.require = false,
    this.show = trueCond,
  });

  String name = '';
  T? value;
  bool editable;
  bool require;
  DocCond show;
  bool isInline = false;

  SQField<T> copy();

  dynamic serialize() => value;

  T? parse(dynamic source);

  SQFormField formField(DocScreenState docScreenState);

  @override
  String toString() => "${name == "" ? "" : "$name:"} $value";
}

abstract class SQFormField<Field extends SQField<dynamic>>
    extends FormField<SQFormField<Field>> {
  const SQFormField(this.field, this.docScreenState)
      : super(builder: emptyBuilder);

  final Field field;
  final DocScreenState docScreenState;
  SQDoc get doc => docScreenState.doc;

  void onChanged() => docScreenState.refreshScreen();

  static Widget emptyBuilder(FormFieldState<dynamic> s) => Container();

  String get fieldLabelText => field.name + (field.require ? ' *' : '');

  Widget fieldLabel(SQFormFieldState formFieldState) => Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        fieldLabelText,
        style: Theme.of(formFieldState.context).textTheme.headline6,
      ));

  Widget readOnlyBuilder(SQFormFieldState formFieldState) {
    final valueString = field.value.toString();
    return GestureDetector(
      onLongPress: () async {
        ScaffoldMessenger.of(formFieldState.context).showSnackBar(SnackBar(
            duration: const Duration(milliseconds: 500),
            content: Text('Copied field: $valueString')));
        await Clipboard.setData(ClipboardData(text: valueString));
      },
      child: Text(valueString),
    );
  }

  Widget fieldBuilder(SQFormFieldState formFieldState);

  @override
  SQFormFieldState<Field> createState() => SQFormFieldState();
}

class SQFormFieldState<Field extends SQField<dynamic>>
    extends FormFieldState<SQFormField<Field>> {
  SQFormField<Field> get formField => widget as SQFormField<Field>;
  Field get field => formField.field;

  ScreenState get screenState => formField.docScreenState;

  @override
  SQFormField<Field> get value => throw Exception('Do not use FormField.value');

  void onChanged() {
    formField.onChanged();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (field.isInline == false) formField.fieldLabel(this),
            if (field.editable && screenState is FormScreenState)
              formField.fieldBuilder(this)
            else
              formField.readOnlyBuilder(this),
          ],
        ),
      );
}
