import 'package:flutter/material.dart';
import 'package:soar_quest/data/db/sq_doc.dart';

class SQBoolFormField extends DocFormField<SQBoolField> {
  const SQBoolFormField(super.field, {super.onChanged, super.doc, super.key});

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
