import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/fields.dart';
import '../buttons/sq_button.dart';

Future showFieldDialog(
    {required SQDocField field, required BuildContext context}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Set ${field.name}"),
            content: field.formField(),
            actions: [
              SQButton('Cancel', onPressed: () => exitScreen(context)),
              SQButton(
                'Save',
                onPressed: () => exitScreen(context, value: field.value),
              ),
            ]);
      });
}
