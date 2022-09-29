import 'package:flutter/material.dart';
import 'package:soar_quest/data/db/sq_doc.dart';

class SQIntFormField extends DocFormField {
  const SQIntFormField(SQIntField field,
      {required super.onChanged, super.doc, super.key})
      : super(field);

  @override
  State<SQIntFormField> createState() => _SQIntFormFieldState();
}

class _SQIntFormFieldState extends DocFormFieldState<SQIntFormField> {
  final fieldTextController = TextEditingController();

  @override
  void initState() {
    fieldTextController.text = (widget.field.value ?? "").toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: fieldTextController,
      onChanged: (text) {
        widget.field.value = int.tryParse(text);
      },
      onEditingComplete: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: widget.field.name,
      ),
    );
  }
}
