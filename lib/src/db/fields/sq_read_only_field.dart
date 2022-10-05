import 'package:flutter/material.dart';

import '../sq_doc_field.dart';

class SQReadOnlyFormField extends DocFormField {
  const SQReadOnlyFormField(super.field, {super.doc, super.key});

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
