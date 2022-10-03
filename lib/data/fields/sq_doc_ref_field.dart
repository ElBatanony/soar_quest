import 'package:flutter/material.dart';

import '../../app/app_navigator.dart';

import '../../components/buttons/sq_button.dart';
import '../../db.dart';
import '../../data/types/sq_doc_reference.dart';
import '../../screens.dart';

import '../types.dart';

class SQDocRefField extends SQDocField<SQDocRef> {
  SQCollection collection;

  SQDocRefField(super.name,
      {required this.collection, super.value, super.readOnly});

  @override
  Type get type => SQDocRef;

  @override
  SQDocRefField copy() {
    return SQDocRefField(name,
        collection: collection, value: value, readOnly: readOnly);
  }

  @override
  SQDocRef? parse(source) {
    return SQDocRef.parse(source);
  }

  @override
  Map<String, dynamic> collectField() {
    if (value == null) return {};

    return {
      "docId": value!.docId,
      "docIdentifier": value!.docIdentifier,
      "collectionPath": value!.collectionPath
    };
  }

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    return _SQDocRefFormField(this, onChanged: onChanged);
  }
}

class _SQDocRefFormField extends DocFormField<SQDocRefField> {
  const _SQDocRefFormField(super.field, {super.onChanged});

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
