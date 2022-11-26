import 'package:flutter/material.dart';

import '../../screens/collection_screens/select_doc_screen.dart';
import '../../screens/doc_screen.dart';
import '../../screens/form_screen.dart';
import '../../sq_auth.dart';
import '../../ui/sq_button.dart';
import '../sq_action.dart';
import '../sq_collection.dart';
import 'sq_user_ref_field.dart';
import 'types/sq_ref.dart';

export 'types/sq_ref.dart';

class SQRefField extends SQField<SQRef> {
  SQRefField(super.name,
      {required this.collection, super.value, super.editable, super.show});

  SQCollection collection;

  @override
  SQRefField copy() => SQRefField(name,
      collection: collection, value: value, editable: editable, show: show);

  @override
  SQRef? parse(source) {
    if (source is! Map<String, dynamic>) return null;
    return SQRef.parse(source);
  }

  @override
  Map<String, dynamic> serialize() {
    if (value == null) return {};

    return {
      'docId': value!.docId,
      'label': value!.label,
      'collectionPath': value!.collectionPath
    };
  }

  @override
  formField(SQDoc doc, {VoidCallback? onChanged}) =>
      _SQRefFormField(this, doc, onChanged: onChanged);
}

class _SQRefFormField extends SQFormField<SQRefField> {
  const _SQRefFormField(super.field, super.doc, {super.onChanged});

  @override
  Widget readOnlyBuilder(formFieldState) {
    final ref = field.value;
    if (ref == null) return const Text('Not Set');
    final doc = SQCollection.byPath(ref.collectionPath)!.getDoc(ref.docId);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(ref.label),
        if (doc != null)
          GoScreenAction('', screen: DocScreen.new)
              .button(doc, screenState: formFieldState.screenState)
      ],
    );
  }

  @override
  Widget fieldBuilder(formFieldState) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(field.value?.label ?? 'Not Set'),
          if (field.editable)
            SQButton(
              'Select',
              onPressed: () async {
                final retDoc = await SelectDocScreen(
                        title: 'Select ${field.name}',
                        collection: field.collection)
                    .go<SQDoc>(formFieldState.context);

                if (retDoc != null) {
                  final ref = SQRef(
                    docId: retDoc.id,
                    label: retDoc.label,
                    collectionPath: retDoc.collection.path,
                  );
                  field.value = ref;
                  formFieldState.onChanged();
                }
              },
            ),
        ],
      );

  @override
  createState() => _SQRefFormFieldState();
}

class _SQRefFormFieldState extends SQFormFieldState<SQRefField> {
  @override
  void initState() {
    if (SQAuth.isSignedIn &&
        field is SQEditedByField &&
        ScreenState.of(context) is FormScreenState)
      field.value = SQAuth.userDoc!.ref;
    super.initState();
  }
}
