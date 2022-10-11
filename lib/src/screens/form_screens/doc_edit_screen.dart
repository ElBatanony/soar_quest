import 'package:flutter/material.dart';

import '../../../db.dart';
import '../form_screen.dart';

Future updateItem(SQDoc doc, BuildContext context) async {
  return doc.collection.saveDoc(doc);
}

FormScreen docEditScreen(
  SQDoc doc, {
  String? title,
  List<String>? shownFields,
  List<String> hiddenFields = const [],
  String submitButtonText = "Edit",
}) {
  return FormScreen(
    doc,
    submitFunction: updateItem,
    title: title,
    hiddenFields: hiddenFields,
    shownFields: shownFields,
    submitButtonText: submitButtonText,
  );
}
