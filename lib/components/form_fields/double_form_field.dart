import 'package:flutter/material.dart';

import '../doc_form_field.dart';

class SQDoubleFormField extends DocFormField {
  const SQDoubleFormField(super.field, {super.onChanged, super.key});

  @override
  State<SQDoubleFormField> createState() => _SQDoubleFormFieldState();
}

class _SQDoubleFormFieldState extends DocFormFieldState<SQDoubleFormField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (intText) {
        widget.field.value = double.parse(intText);
      },
      onEditingComplete: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: widget.field.name,
      ),
    );
  }
}
