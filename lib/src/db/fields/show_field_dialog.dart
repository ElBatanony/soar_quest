import 'package:flutter/material.dart';

import '../../ui/sq_button.dart';
import '../sq_field.dart';

Future<T?> showFieldDialog<T>(
    {required SQField<T> field, required BuildContext context}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Set ${field.name}"),
            content: field.formField(),
            actions: [
              SQButton('Cancel', onPressed: () => Navigator.pop<T>(context)),
              SQButton(
                'Save',
                onPressed: () => Navigator.pop<T>(context, field.value),
              ),
            ]);
      });
}
