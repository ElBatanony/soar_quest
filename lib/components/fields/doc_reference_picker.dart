import 'package:flutter/material.dart';

import '../../app/app_navigator.dart';
import '../../data.dart';

import '../buttons/sq_button.dart';
import '../../screens/select_doc_screen.dart';

class DocReferenceFieldPicker extends StatefulWidget {
  final SQDocReferenceField docReferenceField;
  final Function updateCallback;

  const DocReferenceFieldPicker(
      {Key? key, required this.docReferenceField, required this.updateCallback})
      : super(key: key);

  @override
  State<DocReferenceFieldPicker> createState() =>
      _DocReferenceFieldPickerState();
}

class _DocReferenceFieldPickerState extends State<DocReferenceFieldPicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.docReferenceField.name),
        Text(widget.docReferenceField.value.doc?.identifier ?? "not set"),
        SQButton(
          'Select Doc',
          onPressed: () async {
            SQDoc? retDoc = await goToScreen(
                SelectDocScreen("Select ${widget.docReferenceField.name}",
                    collection: widget.docReferenceField.value.collection),
                context: context);

            if (retDoc != null) {
              SQDocReference ref =
                  SQDocReference(doc: retDoc, collection: retDoc.collection);
              widget.docReferenceField.value = ref;
              widget.updateCallback();
            }
          },
        ),
      ],
    );
  }
}
