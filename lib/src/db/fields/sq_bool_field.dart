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
  formField({Function? onChanged, required SQDoc doc}) {
    return _SQBoolFormField(this, onChanged: onChanged, doc: doc);
  }
}

class _SQBoolFormField extends SQFormField<SQBoolField> {
  const _SQBoolFormField(super.field, {super.onChanged, required super.doc});

  @override
  createState() => _SQBoolFormFieldState();
}

class _SQBoolFormFieldState extends SQFormFieldState<SQBoolField> {
  @override
  Widget fieldBuilder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ToggleButtons(
          borderRadius: BorderRadius.circular(10),
          constraints: BoxConstraints(minWidth: 100, minHeight: 40),
          onPressed: (index) {
            field.value = index == 1;
            onChanged();
          },
          isSelected: [field.value == false, field.value == true],
          children: [Text("No"), Text("Yes")],
        ),
      ],
    );
  }
}
