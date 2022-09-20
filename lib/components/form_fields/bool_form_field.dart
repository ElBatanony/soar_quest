import 'package:flutter/material.dart';

import '../doc_form_field.dart';

class SQBoolFormField extends DocFormField {
  const SQBoolFormField(super.field, {super.onChanged, super.doc, super.key});

  @override
  State<SQBoolFormField> createState() => _SQBoolFormFieldState();
}

class _SQBoolFormFieldState extends DocFormFieldState<SQBoolFormField> {
  @override
  Widget build(BuildContext context) {
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
}
