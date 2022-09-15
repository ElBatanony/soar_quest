import 'package:flutter/material.dart';

import '../../data/db.dart';

class DocFieldToggleButtons extends StatelessWidget {
  final SQDocField field;
  final SQDoc doc;
  final Function onChangeCallback;
  const DocFieldToggleButtons(this.field, this.doc, this.onChangeCallback,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (field.value != true)
      return ElevatedButton(
          onPressed: () {
            field.value = true;
            doc.updateDoc();
            onChangeCallback();
          },
          child: Text("Set ${field.name} to true"));
    return ElevatedButton(
        onPressed: () {
          field.value = false;
          doc.updateDoc();
          onChangeCallback();
        },
        child: Text("Set ${field.name} to false"));
  }
}
