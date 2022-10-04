import 'package:flutter/material.dart';

import '../db/sq_doc.dart';

class SQStringField extends SQDocField<String> {
  SQStringField(String name,
      {String value = "", super.readOnly, super.required})
      : super(name, value: value);

  @override
  String? parse(source) {
    if (source is String) return source;
    return null;
  }

  @override
  SQStringField copy() => SQStringField(name,
      value: value, readOnly: readOnly, required: this.required);

  @override
  String get value => super.value ?? "";

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    return _SQStringFormField(this, onChanged: onChanged);
  }

  @override
  bool get isNull => value.isEmpty;
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
    fieldTextController.text = field.value.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: fieldTextController,
      onChanged: (text) {
        field.value = text;
        onChanged();
      },
      onEditingComplete: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: field.name,
        labelText: field.name,
      ),
    );
  }
}
