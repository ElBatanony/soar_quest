import 'package:flutter/material.dart';

import '../data/sq_action.dart';
import '../data/sq_collection.dart';
import '../data/types/sq_ref.dart';
import '../screens/collection_screens/select_doc_screen.dart';
import '../screens/doc_screen.dart';
import '../ui/button.dart';

export '../data/types/sq_ref.dart';

class SQRefField extends SQField<SQRef> {
  SQRefField(super.name, {required this.collection});

  SQCollection collection;

  @override
  SQRef? parse(source) {
    if (source is Map<String, dynamic> && source.containsKey('docId'))
      return SQRef.parse(source);
    return super.parse(source);
  }

  @override
  Map<String, dynamic> serialize(value) {
    if (value == null) return {};

    return {
      'docId': value.docId,
      'label': value.label,
      'collectionPath': value.collectionPath
    };
  }

  @override
  formField(docScreen) => _SQRefFormField(this, docScreen);
}

class _SQRefFormField extends SQFormField<SQRef, SQRefField> {
  const _SQRefFormField(super.field, super.docScreen);

  @override
  Widget readOnlyBuilder(context) {
    final ref = getDocValue();
    if (ref == null) return const Text('Not Set');
    final doc = SQCollection.byPath(ref.collectionPath)!.getDoc(ref.docId);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(ref.toString()),
        if (doc != null)
          GoScreenAction('', toScreen: DocScreen.new)
              .button(doc, screen: docScreen)
      ],
    );
  }

  @override
  Widget fieldBuilder(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(getDocValue()?.label ?? 'Not Set'),
          if (field.editable)
            SQButton(
              'Select',
              onPressed: () async {
                final retDoc = await SelectDocScreen(
                        title: 'Select ${field.name}',
                        collection: field.collection)
                    .go<SQDoc>(context);

                if (retDoc != null) {
                  final ref = SQRef(
                    docId: retDoc.id,
                    label: retDoc.label,
                    collectionPath: retDoc.collection.path,
                  );
                  setDocValue(ref);
                }
              },
            ),
        ],
      );
}
