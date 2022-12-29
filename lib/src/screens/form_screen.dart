import 'dart:async';

import 'package:flutter/material.dart';

import '../../fields.dart';
import '../data/sq_collection.dart';
import '../sq_auth.dart';
import '../ui/snackbar.dart';
import 'doc_screen.dart';

class FormScreen extends DocScreen {
  FormScreen(
    this.originalDoc, {
    String? title,
    this.submitButtonText = 'Save',
    super.icon,
    super.isInline,
    super.signedIn,
    this.liveEdit = false,
  }) : super(
            liveEdit
                ? originalDoc
                : originalDoc.collection
                    .newDoc(source: originalDoc.serialize()),
            title: title ?? 'Edit ${originalDoc.collection.id}');

  final String submitButtonText;
  final SQDoc originalDoc;
  final bool liveEdit;

  @mustCallSuper
  void onFieldsChanged(
      FormScreenState formScreenState, SQField<dynamic> field) {
    if (liveEdit && field.isLive)
      unawaited(collection.saveDoc(formScreenState.doc));
  }

  @override
  State<FormScreen> createState() => FormScreenState();

  @override
  Future<T?> go<T extends Object?>(BuildContext context,
          {bool replace = false}) =>
      super.go(context, replace: false);

  Future<void> submitForm(ScreenState screenState) async {
    for (final field in collection.fields) {
      if (field.require && doc.getValue<dynamic>(field.name) == null) {
        showSnackBar('${field.name} is required!',
            context: screenState.context);
        return;
      }

      if (field is SQUpdatedDateField)
        doc.setValue(field.name, SQTimestamp.now());

      if (field is SQEditedByField && SQAuth.isSignedIn)
        doc.setValue(field.name, SQAuth.userDoc!.ref);
    }

    originalDoc.parse(doc.serialize());

    await collection.saveDoc(originalDoc);
    screenState.exitScreen<bool>(true);
  }

  @override
  Widget? navigationBar(ScreenState screenState) => NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (index) async {
          if (index == 0) {
            FocusManager.instance.primaryFocus?.unfocus();
            return screenState.exitScreen();
          }
          await submitForm(screenState);
        },
        destinations: [
          const NavigationDestination(
              icon: Icon(Icons.cancel), label: 'Cancel'),
          NavigationDestination(
              icon: const Icon(Icons.save), label: submitButtonText),
        ],
      );

  @override
  Widget screenBody(ScreenState screenState) => GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: super.screenBody(screenState));
}

class FormScreenState<FS extends FormScreen> extends DocScreenState<FS> {
  FormScreen get formScreen => widget;
}
