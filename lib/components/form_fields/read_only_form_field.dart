import 'package:flutter/material.dart';

import '../doc_form_field.dart';

class ReadOnlyFormField extends DocFormField {
  const ReadOnlyFormField(super.field, {super.onChanged, super.doc, super.key});

  @override
  createState() => _ReadOnlyFormFieldState();
}

class _ReadOnlyFormFieldState extends DocFormFieldState {
  @override
  Widget fieldBuilder(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [Text(field.name), Text(": "), Text(field.value.toString())],
    );
  }
}
