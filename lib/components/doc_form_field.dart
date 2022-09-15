import 'package:flutter/material.dart';

import '../app/app_navigator.dart';
import '../data.dart';

import '../data/types/sq_doc_reference.dart';
import '../data/fields/sq_time_of_day_field.dart';
import '../data/types/sq_time_of_day.dart';
import 'buttons/sq_button.dart';
import 'fields/timestamp_doc_field.dart';
import 'fields/list_field_field.dart';
import 'fields/doc_reference_picker.dart';
import 'fields/file_field_picker.dart';
import 'fields/time_of_day_field_picker.dart';

class DocFormField extends StatefulWidget {
  // TODO: inherit from FormField
  final SQDocField field;
  final Function? onChanged;
  final SQDoc? doc;

  const DocFormField(this.field, {this.onChanged, this.doc, super.key});

  @override
  State<DocFormField> createState() => _DocFormFieldState();

  // TODO: required fields (validate not null)

  static List<DocFormField> generateDocFieldsFields(
    SQDoc doc, {
    List<String> hiddenFields = const [],
  }) {
    return doc.fields
        .where((field) => hiddenFields.contains(field.name) == false)
        .map((field) => DocFormField(
              field,
              doc: doc,
            ))
        .toList();
  }
}

class _DocFormFieldState extends State<DocFormField> {
  final fieldTextController = TextEditingController();

  @override
  void initState() {
    fieldTextController.text = widget.field.value.toString();
    refresh();
    super.initState();
  }

  void refresh() {
    setState(() {});
  }

  void onChanged() {
    if (widget.onChanged != null) widget.onChanged!(widget.field.value);
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.field.readOnly == true) {
      return Text("${widget.field} (read only)");
    }

    if (widget.field.type == int) {
      return TextField(
        onChanged: (intText) {
          widget.field.value = int.parse(intText);
        },
        onEditingComplete: onChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: widget.field.name,
        ),
      );
    }

    if (widget.field.type == bool) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.field.name),
          Switch(
            value: widget.field.value,
            onChanged: (value) {
              setState(() {
                widget.field.value = value;
              });
              onChanged();
            },
          ),
        ],
      );
    }

    if (widget.field.type == String) {
      return TextField(
        controller: fieldTextController,
        onChanged: (text) {
          widget.field.value = text;
        },
        onEditingComplete: onChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: widget.field.name,
          labelText: widget.field.name,
        ),
      );
    }

    if (widget.field.type == SQTimestamp) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.field.name),
          Text(widget.field.value.toString()),
          TimestampDocFieldPicker(
              timestampField: widget.field as SQTimestampField,
              updateCallback: onChanged),
        ],
      );
    }

    // TODO: use variable field and use "is" to check type
    if (widget.field.type == SQTimeOfDay) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.field.name),
          Text(widget.field.value.toString()),
          TimeOfDayFieldPicker(
              timeOfDayField: widget.field as SQTimeOfDayField,
              updateCallback: onChanged),
        ],
      );
    }

    if (widget.field.type == List) {
      return ListFieldField(widget.field as SQDocListField);
    }

    if (widget.field.type == SQDocReference) {
      return DocReferenceFieldPicker(
          docReferenceField: widget.field as SQDocReferenceField,
          updateCallback: onChanged);
    }

    if (widget.field.type == SQFile) {
      if (widget.doc == null) return Text("No doc to upload file to");

      return FileFieldPicker(
          fileField: widget.field as SQFileField,
          doc: widget.doc!,
          storage: FirebaseFileStorage(widget.field.value),
          updateCallback: onChanged);
    }

    if (widget.field.type == Null) {
      return Text("Greetings! This is null!");
    }

    return Text("${widget.field.type} fields not implemented");
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
