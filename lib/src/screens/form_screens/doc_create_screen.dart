import 'package:flutter/material.dart';

import '../../db/sq_collection.dart';
import '../form_screen.dart';

Future createDoc(SQDoc doc, BuildContext context) async {
  return doc.collection.createDoc(doc);
}

DocFormScreen docCreateScreen(
  SQCollection collection, {
  String? title,
  List<SQField> initialFields = const [],
  List<String>? shownFields,
  List<String> hiddenFields = const [],
  String submitButtonText = "Create",
}) {
  title ??= "Create ${collection.singleDocName}";

  SQDoc newDoc = collection.newDoc(initialFields: initialFields);
  newDoc.initialized = true;

  return DocFormScreen(
    newDoc,
    submitFunction: createDoc,
    title: title,
    shownFields: shownFields,
    hiddenFields: hiddenFields,
    submitButtonText: submitButtonText,
  );
}
