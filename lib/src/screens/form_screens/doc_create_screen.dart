import 'package:flutter/material.dart';

import '../../db/sq_collection.dart';
import '../form_screen.dart';
import '../../db/fields/sq_virtual_field.dart';

Future createDoc(SQDoc doc, BuildContext context) async {
  return doc.collection.createDoc(doc);
}

DocFormScreen docCreateScreen(
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
  return DocFormScreen(
    newDoc,
    submitFunction: createDoc,
    title: title,
    shownFields: shownFields,
    hiddenFields: hiddenFields,
    submitButtonText: submitButtonText,
  );
}
