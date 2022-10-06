import 'package:flutter/material.dart';

import '../sq_field.dart';

class SQReadOnlyFormField extends SQFormField {
  const SQReadOnlyFormField(super.field, {super.doc, super.key});

  @override
  createState() => _ReadOnlyFormFieldState();
}

class _ReadOnlyFormFieldState extends SQFormFieldState {
  @override
  Widget fieldBuilder(BuildContext context) {
    return Text(field.value.toString());
  }
}
