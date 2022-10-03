import 'package:flutter/material.dart';

import '../fields.dart';

class SQIntField extends SQDocField<int> {
  SQIntField(super.name, {super.value, super.readOnly});

  @override
  int? parse(source) {
    if (source is int) return source;
    return null;
  }

  @override
  SQIntField copy() => SQIntField(name, value: value, readOnly: readOnly);

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    return _SQIntFormField(this, onChanged: onChanged);
  }
}

class _SQIntFormField extends DocFormField<SQIntField> {
  const _SQIntFormField(super.field, {required super.onChanged});

  @override
  createState() => _SQIntFormFieldState();
}

class _SQIntFormFieldState extends DocFormFieldState<SQIntField> {
  final fieldTextController = TextEditingController();

  @override
  void initState() {
    fieldTextController.text = (field.value ?? "").toString();
    super.initState();
  }

  @override
  Widget fieldBuilder(BuildContext context) {
    return TextField(
      controller: fieldTextController,
      onChanged: (text) {
        field.value = int.tryParse(text);
      },
      onEditingComplete: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: field.name,
      ),
    );
  }
}
