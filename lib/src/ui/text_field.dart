import 'package:flutter/material.dart';

import '../data/sq_field.dart';

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

  String parseFieldValue() => (widget.formField.getDocValue() ?? '').toString();

  @override
  void initState() {
    fieldTextController.text = parseFieldValue();
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (fieldTextController.text != parseFieldValue()) {
      FocusManager.instance.primaryFocus?.unfocus();
      fieldTextController.text = parseFieldValue();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => TextField(
        controller: fieldTextController,
        maxLines: widget.maxLines,
        onChanged: (text) {
          final parsedText = widget.textParse(text);
          if (parsedText != null) {
            widget.formField.setDocValue(parsedText);
            callOnChange();
          }
        },
        onEditingComplete: () {
          FocusManager.instance.primaryFocus?.unfocus();
          fieldTextController.text = parseFieldValue();
          callOnChange();
        },
        decoration: InputDecoration(
          hintText: widget.formField.field.name,
          border: const OutlineInputBorder(),
        ),
      );
}
