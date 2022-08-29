import 'package:flutter/material.dart';

import '../app/app_navigator.dart';
import '../data.dart';

import 'buttons/sq_button.dart';
import 'fields/timestamp_doc_field.dart';
import 'fields/list_field.dart';
import 'fields/doc_reference_picker.dart';
import 'fields/file_field_picker.dart';

class DocFieldField extends StatefulWidget {
  final SQDocField field;
  final Function? onChanged;
  final SQDoc? doc;

  const DocFieldField(this.field, {this.onChanged, this.doc, Key? key})
      : super(key: key);

  @override
  State<DocFieldField> createState() => _DocFieldFieldState();

  static List<DocFieldField> generateDocFieldsFields(SQDoc doc) {
    return doc.fields
        .map((field) => DocFieldField(
              field,
              doc: doc,
            ))
        .toList();
  }
}

class _DocFieldFieldState extends State<DocFieldField> {
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
    if (widget.field.type == int) {
      return TextField(
        onChanged: (intText) {
          widget.field.value = int.parse(intText);
          onChanged();
        },
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
          onChanged();
        },
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
              timestampField: widget.field, updateCallback: onChanged),
        ],
      );
    }

    if (widget.field.type == List) {
      return ListField(widget.field as SQDocListField);
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
            content: DocFieldField(field),
            actions: [
              SQButton('Cancel', onPressed: () => exitScreen(context)),
              SQButton(
                'Save',
                onPressed: () => exitScreen(context, value: field.value),
              ),
            ]);
      });
}
