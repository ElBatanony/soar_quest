import 'package:flutter/material.dart';

import '../data/db.dart';

export 'form_fields/read_only_form_field.dart';
export 'form_fields/field_list_form_field.dart';
export 'form_fields/timestamp_form_field.dart';
export 'form_fields/time_of_day_form_field.dart';
export 'form_fields/file_form_field.dart';
export 'form_fields/dialog_field.dart';

// TODO: move form fields into doc fields files

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

  Widget fieldBuilder(BuildContext context) {
    if (field.readOnly == true) return field.readOnlyField(doc: doc);
    return field.formField(onChanged: onChanged, doc: doc);
  }

  @override
  Widget build(BuildContext context) {
    return fieldBuilder(context);
  }
}
