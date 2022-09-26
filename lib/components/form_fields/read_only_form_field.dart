import 'package:flutter/material.dart';

import '../doc_form_field.dart';

class ReadOnlyFormField extends DocFormField {
  const ReadOnlyFormField(super.field, {super.onChanged, super.doc, super.key});

  @override
  State<ReadOnlyFormField> createState() => _ReadOnlyFormFieldState();
}

class _ReadOnlyFormFieldState extends DocFormFieldState<ReadOnlyFormField> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(widget.field.name),
        Text(": "),
        Text(widget.field.value.toString())
      ],
    );
  }
}
