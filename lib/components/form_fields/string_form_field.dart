import 'package:flutter/material.dart';
import 'package:soar_quest/data/db/sq_doc.dart';

class SQStringFormField extends DocFormField<SQStringField> {
  const SQStringFormField(super.field,
      {required super.onChanged, super.doc, super.key});

  @override
  createState() => _SQStringFormFieldState();
}

class _SQStringFormFieldState extends DocFormFieldState<SQStringField> {
  final fieldTextController = TextEditingController();

  @override
  void initState() {
    fieldTextController.text = field.value.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: fieldTextController,
      onChanged: (text) {
        field.value = text;
        onChanged();
      },
      onEditingComplete: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: field.name,
        labelText: field.name,
      ),
    );
  }
}
