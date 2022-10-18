import 'package:flutter/material.dart';

import '../sq_doc.dart';

class SQDoubleField extends SQField<double> {
  SQDoubleField(super.name, {super.value, super.editable});

  @override
  double? parse(source) {
    if (source is double) return source;
    if (source is int) return source.toDouble();
    return null;
  }

  @override
  SQDoubleField copy() => SQDoubleField(name, value: value, editable: editable);

  @override
  formField({Function? onChanged, SQDoc? doc}) {
    return _SQDoubleFormField(this, onChanged: onChanged);
  }
}

class _SQDoubleFormField extends SQFormField<SQDoubleField> {
  const _SQDoubleFormField(super.field, {super.onChanged});

  @override
  createState() => _SQDoubleFormFieldState();
}

class _SQDoubleFormFieldState extends SQFormFieldState<SQDoubleField> {
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
