import 'package:flutter/material.dart';

import '../sq_doc.dart';

class SQStringField extends SQField<String> {
  SQStringField(super.name, {super.value, super.readOnly, super.isRequired});

  @override
  String? parse(source) {
    if (source is String) return source;
    return null;
  }

  @override
  SQStringField copy() => SQStringField(name,
      value: value, readOnly: readOnly, isRequired: isRequired);

  @override
  SQFormField formField({Function? onChanged, SQDoc? doc}) {
    return _SQStringFormField(this, onChanged: onChanged);
  }
}

class _SQStringFormField extends SQFormField<SQStringField> {
  const _SQStringFormField(super.field, {required super.onChanged});

  @override
  createState() => _SQStringFormFieldState();
}

class _SQStringFormFieldState extends SQFormFieldState<SQStringField> {
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
