import 'package:flutter/material.dart';

import '../sq_collection.dart';
import 'types/sq_ref.dart';
import '../../ui/sq_button.dart';
import '../../../screens.dart';

export 'types/sq_ref.dart';

class SQRefField extends SQField<SQRef> {
  SQCollection collection;

  SQRefField(super.name,
      {required this.collection, super.value, super.readOnly});

  @override
  Type get type => SQRef;

  @override
  SQRefField copy() {
    return SQRefField(name,
        collection: collection, value: value, readOnly: readOnly);
  }

  @override
  SQRef? parse(source) {
    if (source is! Map<String, dynamic>) return null;
    return SQRef.parse(source);
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
    return _SQRefFormField(this, onChanged: onChanged);
  }
}

class _SQRefFormField extends DocFormField<SQRefField> {
  const _SQRefFormField(super.field, {super.onChanged});

  @override
  createState() => _SQRefFormFieldState();
}

class _SQRefFormFieldState extends DocFormFieldState<SQRefField> {
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
                SQRef ref = SQRef(
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
