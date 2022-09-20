import 'package:flutter/material.dart';

import '../app/app_navigator.dart';

import '../data/db.dart';
import 'buttons/sq_button.dart';

export 'form_fields/bool_form_field.dart';
export 'form_fields/int_form_field.dart';
export 'form_fields/field_list_form_field.dart';
export 'form_fields/string_form_field.dart';
export 'form_fields/timestamp_form_field.dart';
export 'form_fields/time_of_day_form_field.dart';
export 'form_fields/doc_ref_form_field.dart';
export 'form_fields/file_form_field.dart';
export 'form_fields/double_form_field.dart';

class DocFormField extends StatefulWidget {
  // TODO: inherit from FormField
  final SQDocField field;
  final Function? onChanged;
  final SQDoc? doc;

  const DocFormField(this.field, {this.onChanged, this.doc, super.key});

  @override
  State<DocFormField> createState() => DocFormFieldState();
}

class DocFormFieldState<T extends DocFormField> extends State<T> {
  void onChanged() {
    if (widget.onChanged != null) widget.onChanged!(widget.field.value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.field.readOnly == true) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text("${widget.field}"),
      );
    }

    if (widget.field.type == Null) {
      return Text("Greetings! This is null!");
    }

    return widget.field.formField(onChanged: onChanged, doc: widget.doc);
  }
}

Future showFieldDialog(
    {required BuildContext context, required SQDocField field}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Update ${field.name}"),
            content: DocFormField(field),
            actions: [
              SQButton('Cancel', onPressed: () => exitScreen(context)),
              SQButton(
                'Save',
                onPressed: () => exitScreen(context, value: field.value),
              ),
            ]);
      });
}
