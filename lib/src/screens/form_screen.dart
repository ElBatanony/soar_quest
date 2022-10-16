import 'package:flutter/material.dart';

import '../db/fields/sq_virtual_field.dart';
import '../db/sq_collection.dart';
import '../db/fields/sq_user_ref_field.dart';
import '../ui/sq_button.dart';
import '../ui/snackbar.dart';
import 'screen.dart';

class FormScreen extends Screen {
  late final SQDoc doc;
  final List<String>? hiddenFields;
  final String submitButtonText;
  final List<String>? shownFields;

  SQCollection get collection => doc.collection;

  FormScreen(
    this.doc, {
    String? title,
    this.hiddenFields,
    this.shownFields,
    this.submitButtonText = "Save",
    super.key,
  }) : super(title ?? "Edit ${doc.collection.singleDocName}");

  @override
  State<FormScreen> createState() => FormScreenState();
}

class FormScreenState<T extends FormScreen> extends ScreenState<T> {
  @override
  void initState() {
    if (widget.doc.initialized == false)
      widget.collection
          .ensureInitialized(widget.doc)
          .then((_) => refreshScreen());

    for (var field in widget.doc.fields)
      if (field.runtimeType == SQEditedByField)
        field.value = SQUserRefField.currentUserRef;

    super.initState();
  }

  Future submitForm() async {
    for (SQField field in widget.doc.fields) {
      if (field.isRequired && field.value == null) {
        showSnackBar("${field.name} is required!", context: context);
        return;
      }
    }

    await widget.collection.saveDoc(widget.doc).then(
          (_) => exitScreen<bool>(context, value: true),
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
          hiddenFields: widget.hiddenFields ?? [],
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

  fields = fields.where((field) => field is! SQVirtualField).toList();

  return fields
      .map((field) => field.formField(onChanged: onChanged, doc: doc))
      .toList();
}
