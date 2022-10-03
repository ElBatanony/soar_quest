import 'package:flutter/material.dart';
import 'package:soar_quest/data/db/sq_doc.dart';

// TODO: make SQDoubleFormField inherit from SQStringFormField
class SQDoubleFormField extends DocFormField<SQDoubleField> {
  const SQDoubleFormField(super.field, {super.onChanged, super.key});

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
