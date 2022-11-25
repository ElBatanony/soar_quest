import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/form_screen.dart';
import 'sq_doc.dart';

export 'package:flutter/material.dart' show VoidCallback;

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

  SQFormField formField(SQDoc doc, {VoidCallback? onChanged});

  @override
  String toString() {
    return "${name == "" ? "" : "$name:"} $value";
  }
}

abstract class SQFormField<Field extends SQField<dynamic>>
    extends FormField<SQFormField<Field>> {
  final Field field;
  final SQDoc doc;
  final VoidCallback? onChanged;

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

  late ScreenState screenState;

  @override
  SQFormField<Field> get value => throw "Do not use FormField.value";

  @override
  void initState() {
    screenState = ScreenState.of(context);
    inForm = ScreenState.of(context) is FormScreenState;
    super.initState();
  }

  void onChanged() {
    if (formField.onChanged != null) formField.onChanged!();
    setState(() {});
  }

  String get fieldLabelText => field.name + (field.require ? " *" : "");

  Widget fieldLabel(ScreenState screenState) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(fieldLabelText,
          style: Theme.of(screenState.context).textTheme.headline6),
    );
  }

  Widget readOnlyBuilder(ScreenState screenState) {
    final valueString = field.value.toString();
    return GestureDetector(
      onLongPress: () async {
        Clipboard.setData(ClipboardData(text: valueString));
        ScaffoldMessenger.of(screenState.context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 500),
            content: Text('Copied field: $valueString')));
      },
      child: Text(valueString),
    );
  }

  Widget fieldBuilder(ScreenState screenState);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (field.isInline == false) fieldLabel(screenState),
          if (field.editable && inForm)
            fieldBuilder(screenState)
          else
            readOnlyBuilder(screenState),
        ],
      ),
    );
  }
}
