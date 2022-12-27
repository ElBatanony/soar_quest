import 'package:flutter/material.dart';

import '../sq_doc.dart';

class SQBoolField extends SQField<bool> {
  SQBoolField(super.name, {super.defaultValue, super.editable, super.show});

  @override
  formField(docScreenState) => _SQBoolFormField(this, docScreenState);
}

class _SQBoolFormField extends SQFormField<bool, SQBoolField> {
  const _SQBoolFormField(super.field, super.docScreenState);

  @override
  Widget fieldBuilder(context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ToggleButtons(
            borderRadius: BorderRadius.circular(10),
            constraints: const BoxConstraints(minWidth: 100, minHeight: 40),
            onPressed: (index) {
              setDocValue(index == 1);
            },
            isSelected: [
              doc.getValue<bool>(field.name) == false,
              doc.getValue<bool>(field.name) ?? false,
            ],
            children: const [Text('No'), Text('Yes')],
          ),
        ],
      );
}