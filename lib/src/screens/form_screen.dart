import 'package:flutter/material.dart';

import '../db/fields/sq_inverse_ref_field.dart';
import '../db/fields/sq_virtual_field.dart';
import '../db/sq_collection.dart';
import '../db/fields/sq_user_ref_field.dart';
import '../ui/sq_button.dart';
import '../ui/snackbar.dart';
import 'screen.dart';

Future _defaultSubmitDoc(SQDoc doc, BuildContext context) =>
    doc.collection.saveDoc(doc);

class FormScreen extends Screen {
  late final SQDoc doc;
  late final SQCollection collection;
  late final List<String> hiddenFields;
  final String submitButtonText;
  final List<String>? shownFields;
  final Future Function(SQDoc, BuildContext) submitFunction;

  FormScreen({
    SQDoc? doc,
    String? title,
    this.submitFunction = _defaultSubmitDoc,
    List<String>? hiddenFields,
    this.shownFields,
    this.submitButtonText = "Save",
    super.key,
  })  : assert(doc != null),
        super(title ?? "Edit ${doc?.collection.singleDocName}") {
    if (doc != null) {
      this.doc = doc;
      collection = this.doc.collection;
    }
    this.hiddenFields = hiddenFields ?? [];

    this.hiddenFields.addAll(this
        .doc
        .fields
        .where((field) => field is SQVirtualField || field is SQInverseRefField)
        .map((field) => field.name));
  }

  @override
  State<FormScreen> createState() => FormScreenState();

  @override
  SQButton button(BuildContext context, {String? label}) {
    return super
        .button(context, label: label ?? "Edit a ${collection.singleDocName}");
  }
}

class FormScreenState<T extends FormScreen> extends ScreenState<T> {
  @override
  void initState() {
    if (widget.doc.initialized == false)
      widget.collection.loadDoc(widget.doc).then((_) => refreshScreen());

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
      .map((field) => field.formField(onChanged: onChanged, doc: doc))
      .toList();
}
