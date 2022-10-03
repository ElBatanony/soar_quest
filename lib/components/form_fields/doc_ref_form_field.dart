import 'package:flutter/material.dart';

import '../../app/app_navigator.dart';

import '../../data/db.dart';
import '../../data/types/sq_doc_reference.dart';
import '../buttons/sq_button.dart';
import '../../screens.dart';

class SQDocRefFormField extends DocFormField<SQDocRefField> {
  const SQDocRefFormField(super.field, {super.onChanged, super.doc, super.key});

  @override
  createState() => _SQDocRefFormFieldState();
}

class _SQDocRefFormFieldState extends DocFormFieldState<SQDocRefField> {
  @override
  Widget fieldBuilder(BuildContext context) {
    return DocReferenceFieldPicker(
        docReferenceField: field, updateCallback: onChanged);
  }
}

class DocReferenceFieldPicker extends StatefulWidget {
  final SQDocRefField docReferenceField;
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
        Text(widget.docReferenceField.value?.docIdentifier ?? "not-set"),
        if (widget.docReferenceField.readOnly == false)
          SQButton(
            'Select',
            onPressed: () async {
              SQDoc? retDoc = await goToScreen(
                  SelectDocScreen(
                      title: "Select ${widget.docReferenceField.name}",
                      collection: widget.docReferenceField.collection),
                  context: context);

              if (retDoc != null) {
                SQDocRef ref = SQDocRef(
                  docId: retDoc.id,
                  docIdentifier: retDoc.identifier,
                  collectionPath: retDoc.collection.getPath(),
                );
                widget.docReferenceField.value = ref;
                widget.updateCallback();
              }
            },
          ),
      ],
    );
  }
}
