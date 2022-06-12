import 'package:flutter/material.dart';
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
      print("${widget.field.type} ${widget.field.value.runtimeType}");
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
}
