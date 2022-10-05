import 'package:flutter/material.dart';

import '../sq_doc.dart';

class SQBoolField extends SQDocField<bool> {
  SQBoolField(super.name, {super.value, super.readOnly});

  @override
  bool? parse(source) {
    if (source is bool) return source;
    return null;
  }

  @override
  SQBoolField copy() => SQBoolField(name, value: value, readOnly: readOnly);

  @override
  bool get value => super.value ?? false;

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    return _SQBoolFormField(this, onChanged: onChanged);
  }
}

class _SQBoolFormField extends DocFormField<SQBoolField> {
  const _SQBoolFormField(super.field, {super.onChanged});

  @override
  createState() => _SQBoolFormFieldState();
}

class _SQBoolFormFieldState extends DocFormFieldState<SQBoolField> {
  @override
  Widget fieldBuilder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(field.name),
        Switch(
          value: field.value,
          onChanged: (value) {
            field.value = value;
            onChanged();
          },
        ),
      ],
    );
  }
}
