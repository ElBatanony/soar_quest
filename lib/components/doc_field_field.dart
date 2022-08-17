import 'package:flutter/material.dart';
import 'package:soar_quest/components/timestamp_doc_field.dart';
import 'package:soar_quest/data/sq_doc.dart';

class DocFieldField extends StatefulWidget {
  final SQDocField field;
  const DocFieldField(this.field, {Key? key}) : super(key: key);

  @override
  State<DocFieldField> createState() => _DocFieldFieldState();
}

class _DocFieldFieldState extends State<DocFieldField> {
  final fieldTextController = TextEditingController();

  @override
  void initState() {
    fieldTextController.text = widget.field.value.toString();
    super.initState();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.field.type == SQDocFieldType.int) {
      return TextField(
        onChanged: (intText) {
          widget.field.value = int.parse(intText);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: widget.field.name,
        ),
      );
    }

    if (widget.field.type == SQDocFieldType.bool) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.field.name),
          Switch(
            value: widget.field.value ?? false,
            onChanged: (value) {
              setState(() {
                widget.field.value = value;
              });
            },
          ),
        ],
      );
    }

    if (widget.field.type == SQDocFieldType.string) {
      return TextField(
        controller: fieldTextController,
        onChanged: (text) {
          widget.field.value = text;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: widget.field.name,
        ),
      );
    }

    if (widget.field.type == SQDocFieldType.timestamp) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.field.name),
          Text(widget.field.value.toString()),
          TimestampDocFieldPicker(
              timestampField: widget.field, updateCallback: refresh),
        ],
      );
    }

    return Text("${widget.field.type.name} fields not implemented");
  }
}
