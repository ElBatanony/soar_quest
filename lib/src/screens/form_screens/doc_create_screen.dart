import 'package:flutter/material.dart';

import '../../ui/snackbar.dart';
import '../../../db.dart';
import '../form_screen.dart';

Future createDoc(SQDoc doc, BuildContext context) async {
  return doc.collection.createDoc(doc).then((_) {
    showSnackBar("${doc.collection.singleDocName} created", context: context);
  });
}

DocFormScreen docCreateScreen(
  SQCollection collection, {
  String? title,
  List<SQDocField> initialFields = const [],
  List<String>? shownFields,
  List<String> hiddenFields = const [],
  String submitButtonText = "Create",
}) {
  title ??= "Create ${collection.singleDocName}";

  SQDoc newDoc = collection.newDoc(initialFields: initialFields);

  return DocFormScreen(
    newDoc,
    submitFunction: createDoc,
    title: title,
    shownFields: shownFields,
    hiddenFields: hiddenFields,
    submitButtonText: submitButtonText,
  );
}
