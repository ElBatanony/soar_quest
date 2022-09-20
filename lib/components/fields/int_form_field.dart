import 'package:flutter/material.dart';

import '../doc_form_field.dart';

class SQIntFormField extends DocFormField {
  const SQIntFormField(super.field,
      {required super.onChanged, super.doc, super.key});

  @override
  State<SQIntFormField> createState() => _SQIntFormFieldState();
}

class _SQIntFormFieldState extends DocFormFieldState<SQIntFormField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (intText) {
        widget.field.value = int.parse(intText);
      },
      onEditingComplete: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: widget.field.name,
      ),
    );
  }
}
