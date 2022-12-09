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

  SQField<T> copy();

  dynamic serialize() => value;

  T? parse(dynamic source);

  SQFormField formField(DocScreenState docScreenState);

  @override
  String toString() => "${name == "" ? "" : "$name:"} $value";
}

abstract class SQFormField<Field extends SQField<dynamic>>
    extends StatelessWidget {
  const SQFormField(this.field, this.docScreenState);

  final Field field;
  final DocScreenState docScreenState;
  SQDoc get doc => docScreenState.doc;

  String get fieldLabelText => field.name + (field.require ? ' *' : '');

  Widget fieldLabel(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        fieldLabelText,
        style: Theme.of(context).textTheme.headline6,
      ));

  Widget readOnlyBuilder(BuildContext context) {
    final valueString = field.value.toString();
    return GestureDetector(
      onLongPress: () async {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(milliseconds: 500),
            content: Text('Copied field: $valueString')));
        await Clipboard.setData(ClipboardData(text: valueString));
      },
      child: Text(valueString),
    );
  }

  Widget fieldBuilder(BuildContext context);

  void onChanged() => docScreenState.refreshScreen();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (field.isInline == false) fieldLabel(context),
            if (field.editable && docScreenState is FormScreenState)
              fieldBuilder(context)
            else
              readOnlyBuilder(context),
          ],
        ),
      );
}
