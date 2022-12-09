import 'package:flutter/material.dart';

import '../sq_field.dart';

// TODO: move to UI components

class SQTextField<T> extends StatefulWidget {
  const SQTextField(this.formField,
      {required this.textParse, this.maxLines = 1});

  final SQFormField<T, SQField<T>> formField;
  final T Function(String) textParse;
  final int maxLines;

  @override
  SQTextFieldState createState() => SQTextFieldState();
}

class SQTextFieldState extends State<SQTextField<dynamic>> {
  final fieldTextController = TextEditingController();

  void callOnChange() {
    widget.formField.docScreenState.refreshScreen();
    setState(() {});
  }

  String parseFieldValue() => (widget.formField.field.value ?? '').toString();

  @override
  void initState() {
    fieldTextController.text = parseFieldValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => TextField(
        controller: fieldTextController,
        maxLines: widget.maxLines,
        onChanged: (text) {
          widget.formField.field.value = widget.textParse(text);
          callOnChange();
        },
        onEditingComplete: () {
          FocusManager.instance.primaryFocus?.unfocus();
          fieldTextController.text = parseFieldValue();
          callOnChange();
        },
        decoration: const InputDecoration(border: OutlineInputBorder()),
      );
}
