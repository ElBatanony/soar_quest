import 'package:flutter/material.dart';

import '../doc_form_field.dart';

class SQStringFormField extends DocFormField {
  const SQStringFormField(super.field,
      {required super.onChanged, super.doc, super.key});

  @override
  State<SQStringFormField> createState() => _SQStringFormFieldState();
}

class _SQStringFormFieldState extends DocFormFieldState<SQStringFormField> {
  final fieldTextController = TextEditingController();

  @override
  void initState() {
    fieldTextController.text = widget.field.value.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
}
