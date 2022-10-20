import 'package:flutter/material.dart';

import '../sq_field.dart';

class SQTextField<T> extends StatefulWidget {
  final SQFormField<SQField<T>> formField;
  final T Function(String) textParse;

  const SQTextField(this.formField, {required this.textParse});

  @override
  SQTextFieldState createState() => SQTextFieldState();
}

class SQTextFieldState extends State<SQTextField<dynamic>> {
  final fieldTextController = TextEditingController();

  void callOnChange() {
    if (widget.formField.onChanged != null) widget.formField.onChanged!();
    setState(() {});
  }

  String parseFieldValue() => (widget.formField.field.value ?? "").toString();

  @override
  void initState() {
    fieldTextController.text = parseFieldValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: fieldTextController,
      onChanged: (text) {
        widget.formField.field.value = widget.textParse(text);
        callOnChange();
      },
      onEditingComplete: () {
        FocusManager.instance.primaryFocus?.unfocus();
        fieldTextController.text = parseFieldValue();
        callOnChange();
      },
      decoration: InputDecoration(border: OutlineInputBorder()),
    );
  }
}
