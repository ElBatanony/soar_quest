import 'package:flutter/material.dart';

import '../../components/snackbar.dart';
import '../../data/db.dart';
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
  // TODO : maybe use Map<fieldName, fieldValue>. but what about readOnly. another list?
  List<String>? shownFields,
  List<String> hiddenFields = const [],
  String submitButtonText = "Create",
}) {
  title ??= "Create ${collection.singleDocName}";

  String newDocId = collection.getANewDocId();
  SQDoc newDoc = SQDoc(newDocId, collection: collection);

  for (var field in initialFields) {
    SQDocField? newDocField = newDoc.getFieldByName(field.name);
    newDocField?.value = field.value;
    newDocField?.readOnly = field.readOnly;
  }

  for (var field in newDoc.fields)
    if (field.runtimeType == SQCreatedByField)
      field.value = SQUserRefField.currentUserRef;

  return DocFormScreen(
    newDoc,
    submitFunction: createDoc,
    title: title,
    shownFields: shownFields,
    hiddenFields: hiddenFields,
    submitButtonText: submitButtonText,
  );

  // @override
  // SQButton button(BuildContext context, {String? label}) {
  //   return super.button(context,
  //       label: label ?? "Create a ${collection.singleDocName}");
  // }
}
