import 'package:flutter/material.dart';
import 'package:soar_quest/data/db/sq_doc.dart';

class SQIntFormField extends DocFormField<SQIntField> {
  const SQIntFormField(super.field,
      {required super.onChanged, super.doc, super.key});

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
