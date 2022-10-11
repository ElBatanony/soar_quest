import 'package:flutter/material.dart';

import '../../db/sq_collection.dart';
import '../form_screen.dart';
import '../../db/fields/sq_virtual_field.dart';
import '../../db/fields/sq_inverse_ref_field.dart';

Future createDoc(SQDoc doc, BuildContext context) async {
  return doc.collection.saveDoc(doc);
}

FormScreen docCreateScreen(
  SQCollection collection, {
  String? title,
  List<SQField> initialFields = const [],
  List<String>? shownFields,
  List<String>? hiddenFields,
  String submitButtonText = "Create",
}) {
  title ??= "Create ${collection.singleDocName}";

  SQDoc newDoc = collection.newDoc(initialFields: initialFields);
  newDoc.initialized = true;

  hiddenFields ??= [];

  hiddenFields.addAll(
      newDoc.fields.whereType<SQVirtualField>().map((field) => field.name));

  hiddenFields.addAll(
      newDoc.fields.whereType<SQInverseRefField>().map((field) => field.name));

  return FormScreen(
    newDoc,
    submitFunction: createDoc,
    title: title,
    shownFields: shownFields,
    hiddenFields: hiddenFields,
    submitButtonText: submitButtonText,
  );
}
