import 'package:flutter/material.dart';

import '../../screens/screen.dart';
import '../../ui/sq_button.dart';
import '../sq_field.dart';

Future showFieldDialog<T>(
    {required SQField<T> field, required BuildContext context}) {
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
                onPressed: () => exitScreen<T>(context, value: field.value),
              ),
            ]);
      });
}
