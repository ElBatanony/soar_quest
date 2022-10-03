import 'package:flutter/material.dart';

import '../fields.dart';

class SQDoubleField extends SQDocField<double> {
  SQDoubleField(super.name, {super.value, super.readOnly});

  @override
  double? parse(source) {
    if (source is double) return source;
    if (source is int) return source.toDouble();
    return null;
  }

  @override
  SQDoubleField copy() => SQDoubleField(name, value: value, readOnly: readOnly);

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    return _SQDoubleFormField(this, onChanged: onChanged);
  }
}

class _SQDoubleFormField extends DocFormField<SQDoubleField> {
  const _SQDoubleFormField(super.field, {super.onChanged});

  @override
  createState() => _SQDoubleFormFieldState();
}

class _SQDoubleFormFieldState extends DocFormFieldState<SQDoubleField> {
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
        field.value = double.tryParse(text);
        onChanged();
      },
      onEditingComplete: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: field.name,
      ),
    );
  }
}
