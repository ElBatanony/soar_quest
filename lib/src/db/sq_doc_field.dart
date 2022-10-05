import 'package:flutter/material.dart';

import 'sq_doc.dart';
import 'fields/sq_read_only_field.dart';

// TODO: rename to SQField
abstract class SQDocField<T> {
  String name = "";
  T? value;
  Type get type => T;
  bool readOnly;
  bool required;

  SQDocField(
    this.name, {
    this.value,
    this.readOnly = false,
    this.required = false,
  });

  SQDocField copy();

  dynamic collectField() => value;

  T? parse(dynamic source);

  DocFormField formField({Function? onChanged, SQDoc? doc});

  DocFormField readOnlyField({SQDoc? doc}) {
    return SQReadOnlyFormField(this, doc: doc);
  }

  @override
  String toString() {
    return "${name == "" ? "" : "$name:"} $value";
  }

  bool get isNull => value == null;
}

// TODO: rename to SQFormField
abstract class DocFormField<DocField extends SQDocField>
    extends FormField<DocFormField<DocField>> {
  final DocField field;
  final Function? onChanged;
  final SQDoc? doc;

  const DocFormField(this.field, {this.onChanged, this.doc, super.key})
      : super(builder: emptyBuilder);

  static Widget emptyBuilder(FormFieldState s) => Container();

  @override
  DocFormFieldState<DocField> createState();
}

abstract class DocFormFieldState<DocField extends SQDocField>
    extends FormFieldState<DocFormField<DocField>> {
  DocFormField<DocField> get formField => (widget as DocFormField<DocField>);
  DocField get field => formField.field;
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
