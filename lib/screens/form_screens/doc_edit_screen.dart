import 'package:flutter/material.dart';

import '../../data/db.dart';
import '../form_screen.dart';

Future updateItem(SQDoc doc, BuildContext context) async {
  return doc.collection.updateDoc(doc).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("${doc.collection.singleDocName} updated"),
    ));
  });
}

DocFormScreen docEditScreen(
  SQDoc doc, {
  String? title,
  List<String> shownFields = const [],
  List<String> hiddenFields = const [],
  String submitButtonText = "Create",
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
