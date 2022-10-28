import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/form_screen.dart';
import '../screens/screen.dart';
import 'conditions.dart';
import 'sq_doc.dart';

abstract class SQField<T> {
  String name = "";
  T? value;
  bool editable;
  bool require;
  DocCond show;
  bool isInline = false;

  SQField(
    this.name, {
    this.value,
    this.editable = true,
    this.require = false,
    this.show = trueCond,
  });

  SQField<T> copy();

  dynamic serialize() => value;

  T? parse(dynamic source);

  SQFormField formField(SQDoc doc, {Function? onChanged});

  @override
  String toString() {
    return "${name == "" ? "" : "$name:"} $value";
  }
}

abstract class SQFormField<Field extends SQField<dynamic>>
    extends FormField<SQFormField<Field>> {
  final Field field;
  final SQDoc doc;
  final Function? onChanged;

  const SQFormField(this.field, this.doc, {this.onChanged, super.key})
      : super(builder: emptyBuilder);

  static Widget emptyBuilder(FormFieldState<dynamic> s) => Container();

  @override
  SQFormFieldState<Field> createState();
}

abstract class SQFormFieldState<Field extends SQField<dynamic>>
    extends FormFieldState<SQFormField<Field>> {
  SQFormField<Field> get formField => (widget as SQFormField<Field>);
  Field get field => formField.field;
  SQDoc get doc => formField.doc;
  late bool inForm;

  @override
  SQFormField<Field> get value => throw "Do not use FormField.value";

  @override
  void initState() {
    inForm = ScreenState.of(context) is FormScreenState;
    super.initState();
  }

  void onChanged() {
    if (formField.onChanged != null) formField.onChanged!();
    setState(() {});
  }

  Widget fieldLabel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(field.name + (field.require ? " *" : ""),
          style: Theme.of(context).textTheme.headline6),
    );
  }

  Widget readOnlyBuilder(BuildContext context) {
    String valueString = field.value.toString();
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: valueString));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 500),
            content: Text('Copied field: $valueString')));
      },
      child: Text(valueString),
    );
  }

  Widget fieldBuilder(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (field.isInline == false) fieldLabel(context),
          (field.editable && inForm)
              ? fieldBuilder(context)
              : readOnlyBuilder(context),
        ],
      ),
    );
  }
}
