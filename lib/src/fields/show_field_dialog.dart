import 'package:flutter/material.dart';

import '../../app.dart';
import '../components/buttons/sq_button.dart';
import '../../data/fields.dart';

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
