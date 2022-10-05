import 'package:flutter/material.dart';

import '../sq_doc.dart';

class SQStringField extends SQDocField<String> {
  SQStringField(super.name, {super.value, super.readOnly, super.required});

  @override
  String? parse(source) {
    if (source is String) return source;
    return null;
  }

  @override
  SQStringField copy() => SQStringField(name,
      value: value, readOnly: readOnly, required: this.required);

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    return _SQStringFormField(this, onChanged: onChanged);
  }
}

class _SQStringFormField extends DocFormField<SQStringField> {
  const _SQStringFormField(super.field, {required super.onChanged});

  @override
  createState() => _SQStringFormFieldState();
}

class _SQStringFormFieldState extends DocFormFieldState<SQStringField> {
  final fieldTextController = TextEditingController();

  @override
  void initState() {
    fieldTextController.text = field.value ?? "";
    super.initState();
  }

  @override
  Widget fieldBuilder(BuildContext context) {
    return TextField(
      controller: fieldTextController,
      onChanged: (text) {
        field.value = text;
        onChanged();
      },
      onEditingComplete: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }
}
