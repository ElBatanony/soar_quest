import 'package:flutter/material.dart';

import '../../ui/sq_button.dart';
import '../../../screens.dart';
import '../sq_collection.dart';
import 'sq_user_ref_field.dart';
import 'types/sq_ref.dart';

export 'types/sq_ref.dart';

class SQRefField extends SQField<SQRef> {
  SQCollection collection;

  SQRefField(super.name,
      {required this.collection, super.value, super.editable});

  @override
  SQRefField copy() {
    return SQRefField(name,
        collection: collection, value: value, editable: editable);
  }

  @override
  SQRef? parse(source) {
    if (source is! Map<String, dynamic>) return null;
    return SQRef.parse(source);
  }

  @override
  Map<String, dynamic> serialize() {
    if (value == null) return {};

    return {
      "docId": value!.docId,
      "label": value!.label,
      "collectionPath": value!.collectionPath
    };
  }

  @override
  formField({Function? onChanged, SQDoc? doc}) {
    return _SQRefFormField(this, onChanged: onChanged);
  }
}

class _SQRefFormField extends SQFormField<SQRefField> {
  const _SQRefFormField(super.field, {super.onChanged});

  @override
  createState() => _SQRefFormFieldState();
}

class _SQRefFormFieldState extends SQFormFieldState<SQRefField> {
  @override
  void initState() {
    if (field is SQEditedByField && ScreenState.of(context) is FormScreenState)
      field.value = SQUserRefField.currentUserRef;
    super.initState();
  }

  @override
  Widget fieldBuilder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(field.value?.label ?? "not-set"),
        if (field.editable)
          SQButton(
            'Select',
            onPressed: () async {
              SQDoc? retDoc = await SelectDocScreen(
                      title: "Select ${field.name}",
                      collection: field.collection)
                  .go<SQDoc>(context);

              if (retDoc != null) {
                SQRef ref = SQRef(
                  docId: retDoc.id,
                  label: retDoc.label,
                  collectionPath: retDoc.collection.path,
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
