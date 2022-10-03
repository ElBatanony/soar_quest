import 'package:flutter/material.dart';

import '../db.dart';

export 'fields/sq_field_list_field.dart';
export 'fields/sq_doc_ref_field.dart';
export 'fields/sq_file_field.dart';
export 'fields/sq_time_of_day_field.dart';
export 'fields/sq_timestamp_field.dart';
export 'fields/sq_user_ref_field.dart';
export 'fields/sq_updated_date_field.dart';
export 'fields/sq_string_field.dart';
export 'fields/sq_bool_field.dart';
export 'fields/sq_int_field.dart';
export 'fields/sq_video_link_field.dart';
export 'fields/sq_double_field.dart';
export 'fields/sq_list_field.dart';
export 'fields/sq_inverse_ref_field.dart';
export 'fields/sq_read_only_field.dart';
export 'fields/show_field_dialog.dart';

export '../data/db/sq_doc.dart';

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
