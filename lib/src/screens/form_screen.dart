import 'package:flutter/material.dart';

import '../db/sq_collection.dart';
import '../db/fields/sq_user_ref_field.dart';
import '../ui/sq_button.dart';
import '../ui/snackbar.dart';
import 'screen.dart';

class DocFormScreen extends Screen {
  late final SQCollection collection;
  final List<String> hiddenFields;
  final String submitButtonText;
  final List<String>? shownFields;
  final SQDoc doc;
  final Future Function(SQDoc, BuildContext) submitFunction;

  DocFormScreen(
    this.doc, {
    String? title,
    required this.submitFunction,
    this.hiddenFields = const [],
    this.shownFields = const [],
    this.submitButtonText = "Submit",
    super.key,
  }) : super(title ?? "Edit ${doc.collection.singleDocName}") {
    collection = doc.collection;
  }

  @override
  State<DocFormScreen> createState() => DocFormScreenState();

  @override
  SQButton button(BuildContext context, {String? label}) {
    return super
        .button(context, label: label ?? "Edit a ${collection.singleDocName}");
  }
}

class DocFormScreenState<T extends DocFormScreen> extends ScreenState<T> {
  @override
  void initState() {
    if (widget.doc.initialized == false)
      widget.doc.loadDoc().then((_) => refreshScreen());

    for (var field in widget.doc.fields)
      if (field.runtimeType == SQEditedByField)
        field.value = SQUserRefField.currentUserRef;

    super.initState();
  }

  Future submitForm() async {
    for (SQField field in widget.doc.fields) {
      if (field.isRequired && field.isNull) {
        showSnackBar("${field.name} is required!", context: context);
        return;
      }
    }

    await widget.submitFunction(widget.doc, context).then(
          (_) => exitScreen(context, value: true),
        );
  }

  @override
  Widget screenBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._generateDocFormFields(
          widget.doc,
          shownFields: widget.shownFields,
          hiddenFields: widget.hiddenFields,
          onChanged: refreshScreen,
        ),
        SQButton(widget.submitButtonText, onPressed: submitForm)
      ],
    );
  }
}

List<SQFormField> _generateDocFormFields(
  SQDoc doc, {
  List<String> hiddenFields = const [],
  List<String>? shownFields,
  Function? onChanged,
}) {
  List<SQField> fields = doc.fields;

  if (shownFields != null)
    fields = fields
        .where((field) => shownFields.contains(field.name) == true)
        .toList();

  fields = fields
      .where((field) => hiddenFields.contains(field.name) == false)
      .toList();

  return fields
      .map((field) => field.readOnly
          ? field.readOnlyField(doc: doc)
          : field.formField(onChanged: onChanged, doc: doc))
      .toList();
}
