import 'package:flutter/material.dart';

import '../app.dart';
import '../components/buttons/sq_button.dart';
import 'db.dart';

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

export '../data/db/sq_doc.dart';
export '../components/doc_form_field.dart';

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
    return _ReadOnlyFormField(this, doc: doc);
  }

  @override
  String toString() {
    return "${name == "" ? "" : "$name:"} $value";
  }

  bool get isNull => value == null;
}

class _ReadOnlyFormField extends DocFormField {
  const _ReadOnlyFormField(super.field, {super.doc});

  @override
  createState() => _ReadOnlyFormFieldState();
}

class _ReadOnlyFormFieldState extends DocFormFieldState {
  @override
  Widget fieldBuilder(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [Text(field.name), Text(": "), Text(field.value.toString())],
    );
  }
}

Future showFieldDialog(
    {required SQDocField field, required BuildContext context}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Set ${field.name}"),
            content: field.formField(),
            actions: [
              SQButton('Cancel', onPressed: () => exitScreen(context)),
              SQButton(
                'Save',
                onPressed: () => exitScreen(context, value: field.value),
              ),
            ]);
      });
}
