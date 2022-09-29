import 'package:flutter/material.dart';
import 'package:soar_quest/data/db/sq_doc.dart';

class SQDoubleFormField extends DocFormField {
  const SQDoubleFormField(SQDoubleField field, {super.onChanged, super.key})
      : super(field);

  @override
  State<SQDoubleFormField> createState() => _SQDoubleFormFieldState();
}

class _SQDoubleFormFieldState extends DocFormFieldState<SQDoubleFormField> {
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
        widget.field.value = double.tryParse(text);
        onChanged();
      },
      onEditingComplete: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: widget.field.name,
      ),
    );
  }
}
