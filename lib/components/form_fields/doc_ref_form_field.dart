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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(field.name),
        Text(field.value?.docIdentifier ?? "not-set"),
        if (field.readOnly == false)
          SQButton(
            'Select',
            onPressed: () async {
              SQDoc? retDoc = await goToScreen(
                  SelectDocScreen(
                      title: "Select ${field.name}",
                      collection: field.collection),
                  context: context);

              if (retDoc != null) {
                SQDocRef ref = SQDocRef(
                  docId: retDoc.id,
                  docIdentifier: retDoc.identifier,
                  collectionPath: retDoc.collection.getPath(),
                );
                field.value = ref;
                onChanged();
              }
            },
          ),
      ],
    );
  }
}
