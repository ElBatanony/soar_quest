import 'package:flutter/material.dart';
import 'package:soar_quest/components/list_field.dart';
import 'package:soar_quest/components/timestamp_doc_field.dart';

import '../data.dart';
import 'doc_reference_picker.dart';

class DocFieldField extends StatefulWidget {
  final SQDocField field;
  final Function? onChanged;

  const DocFieldField(this.field, {this.onChanged, Key? key}) : super(key: key);

  @override
  State<DocFieldField> createState() => _DocFieldFieldState();
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
              timestampField: widget.field,
              updateCallback: () {
                refresh();
                onChanged();
              }),
        ],
      );
    }

    if (widget.field.type == List) {
      return ListField(widget.field as SQDocListField);
    }

    if (widget.field.type == SQDocReference) {
      return DocReferenceFieldPicker(
        docReferenceField: widget.field as SQDocReferenceField,
        updateCallback: () {
          refresh();
          onChanged();
        },
      );
    }

    if (widget.field.type == Null) {
      return Text("Greetings! This is null!");
    }

    return Text("${widget.field.type} fields not implemented");
  }
}
