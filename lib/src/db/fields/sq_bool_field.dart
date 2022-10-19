import 'package:flutter/material.dart';

import '../sq_doc.dart';

class SQBoolField extends SQField<bool> {
  SQBoolField(super.name, {super.value, super.editable});

  @override
  bool? parse(source) {
    if (source is bool) return source;
    return null;
  }

  @override
  SQBoolField copy() => SQBoolField(name, value: value, editable: editable);

  @override
  formField({Function? onChanged, SQDoc? doc}) {
    return _SQBoolFormField(this, onChanged: onChanged);
  }
}

class _SQBoolFormField extends SQFormField<SQBoolField> {
  const _SQBoolFormField(super.field, {super.onChanged});

  @override
  createState() => _SQBoolFormFieldState();
}

class _SQBoolFormFieldState extends SQFormFieldState<SQBoolField> {
  @override
  Widget fieldBuilder(BuildContext context) {
    return Switch(
      value: field.value,
      onChanged: (value) {
        field.value = value;
        onChanged();
      },
    );
  }
}
