import 'package:flutter/material.dart';

import '../../ui/snackbar.dart';
import '../../../db.dart';
import '../form_screen.dart';

Future updateItem(SQDoc doc, BuildContext context) async {
  return doc.collection.saveDoc(doc).then((_) {
    showSnackBar("${doc.collection.singleDocName} updated", context: context);
  });
}

DocFormScreen docEditScreen(
  SQDoc doc, {
  String? title,
  List<String>? shownFields,
  List<String> hiddenFields = const [],
  String submitButtonText = "Edit",
}) {
  return DocFormScreen(
    doc,
    submitFunction: updateItem,
    title: title,
    hiddenFields: hiddenFields,
    shownFields: shownFields,
    submitButtonText: submitButtonText,
  );
}
