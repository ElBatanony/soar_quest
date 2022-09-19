import 'package:flutter/material.dart';

import '../app/app_navigator.dart';

import '../data/db.dart';
import '../data/types.dart';
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
    List<String>? shownFields,
  }) {
    List<SQDocField> fields = doc.fields;

    if (shownFields != null)
      fields = fields
          .where((field) => shownFields.contains(field.name) == true)
          .toList();

    fields = fields
        .where((field) => hiddenFields.contains(field.name) == false)
        .toList();

    return fields
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
    final SQDocField field = widget.field;

    if (field.readOnly == true) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text("$field"),
      );
    }

    if (field is SQIntField) {
      return TextField(
        onChanged: (intText) {
          field.value = int.parse(intText);
        },
        onEditingComplete: onChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: field.name,
        ),
      );
    }

    if (field is SQBoolField) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(field.name),
          Switch(
            value: field.value,
            onChanged: (value) {
              setState(() {
                field.value = value;
              });
              onChanged();
            },
          ),
        ],
      );
    }

    if (field is SQStringField) {
      return TextField(
        controller: fieldTextController,
        onChanged: (text) {
          field.value = text;
        },
        onEditingComplete: onChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: field.name,
          labelText: field.name,
        ),
      );
    }

    if (field is SQTimestampField) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(field.name),
          Text(field.value.toString()),
          TimestampDocFieldPicker(
              timestampField: field, updateCallback: onChanged),
        ],
      );
    }

    if (field is SQTimeOfDayField) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(field.name),
          Text(field.value.toString()),
          TimeOfDayFieldPicker(
              timeOfDayField: field, updateCallback: onChanged),
        ],
      );
    }

    if (field is SQDocListField) {
      return ListFieldField(field);
    }

    if (field is SQDocReferenceField) {
      return DocReferenceFieldPicker(
          docReferenceField: field, updateCallback: onChanged);
    }

    if (field is SQFileField) {
      if (widget.doc == null) return Text("No doc to upload file to");

      return FileFieldPicker(
          fileField: field,
          doc: widget.doc!,
          storage: FirebaseFileStorage(field.value),
          updateCallback: onChanged);
    }

    if (field.type == Null) {
      return Text("Greetings! This is null!");
    }

    return Text("${field.type} fields not implemented");
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
