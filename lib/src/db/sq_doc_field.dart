import 'package:flutter/material.dart';

import 'sq_doc.dart';
import 'fields/sq_read_only_field.dart';

abstract class SQField<T> {
  String name = "";
  T? value;
  Type get type => T;
  bool readOnly;
  bool required;

  SQField(
    this.name, {
    this.value,
    this.readOnly = false,
    this.required = false,
  });

  SQField copy();

  dynamic collectField() => value;

  T? parse(dynamic source);

  SQFormField formField({Function? onChanged, SQDoc? doc});

  SQFormField readOnlyField({SQDoc? doc}) {
    return SQReadOnlyFormField(this, doc: doc);
  }

  @override
  String toString() {
    return "${name == "" ? "" : "$name:"} $value";
  }

  bool get isNull => value == null;
}

abstract class SQFormField<Field extends SQField>
    extends FormField<SQFormField<Field>> {
  final Field field;
  final Function? onChanged;
  final SQDoc? doc;

  const SQFormField(this.field, {this.onChanged, this.doc, super.key})
      : super(builder: emptyBuilder);

  static Widget emptyBuilder(FormFieldState s) => Container();

  @override
  SQFormFieldState<Field> createState();
}

abstract class SQFormFieldState<Field extends SQField>
    extends FormFieldState<SQFormField<Field>> {
  SQFormField<Field> get formField => (widget as SQFormField<Field>);
  Field get field => formField.field;
  SQDoc? get doc => formField.doc;

  void onChanged() {
    if (formField.onChanged != null) formField.onChanged!();
    setState(() {});
  }

  Widget fieldLabel() {
    // TODO: add * if required
    return Text(field.name, style: Theme.of(context).textTheme.headline6);
  }

  Widget fieldBuilder(BuildContext context) {
    if (field.readOnly == true) return field.readOnlyField(doc: doc);
    return field.formField(onChanged: onChanged, doc: doc);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fieldLabel(),
          SizedBox(height: 4),
          fieldBuilder(context),
        ],
      ),
    );
  }
}
