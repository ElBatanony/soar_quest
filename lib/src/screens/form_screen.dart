import 'dart:async';

import 'package:flutter/material.dart';

import '../../fields.dart';
import '../data/sq_collection.dart';
import '../ui/button.dart';
import '../ui/snackbar.dart';
import 'doc_screen.dart';

class FormScreen extends DocScreen {
  FormScreen(
    this.originalDoc, {
    String? title,
    this.submitButtonText = 'Save',
    super.icon,
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
  void onFieldsChanged(SQField<dynamic> field) {
    if (liveEdit && field.isLive) unawaited(collection.saveDoc(doc));
  }

  @override
  Future<T?> go<T extends Object?>(BuildContext context,
          {bool replace = false}) =>
      super.go(context, replace: false);

  Future<void> submitForm() async {
    for (final field in collection.fields) {
      if (field.require && doc.getValue<dynamic>(field.name) == null) {
        showSnackBar('${field.name} is required!', context: context);
        return;
      }

      if (field is SQUpdatedDateField)
        doc.setValue(field.name, SQTimestamp.now());
    }

    originalDoc.parse(doc.serialize());

    await collection.saveDoc(originalDoc);
    exitScreen<bool>(true);
  }

  @override
  Widget? navigationBar() => null;

  @override
  Widget screenBody() => GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            super.screenBody(),
            SQButton('Add ${collection.id}', onPressed: submitForm)
          ],
        ),
      ));
}
