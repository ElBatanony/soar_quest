import 'package:flutter/material.dart';

import '../app.dart';
import '../components/buttons/sq_button.dart';
import '../components/doc_form_field.dart';
import '../data/db.dart';
import 'screen.dart';

class DocCreateScreen extends Screen {
  final SQCollection collection;
  final List<SQDocField> initialFields;
  final List<String> hiddenFields;
  final String submitButtonText;

  DocCreateScreen(
    this.collection, {
    String? title,
    this.initialFields = const [],
    this.hiddenFields = const [],
    this.submitButtonText = "Create",
    super.key,
  }) : super(title ?? "Create ${collection.singleDocName}");

  @override
  State<DocCreateScreen> createState() => _DocCreateScreenState();
}

class _DocCreateScreenState extends ScreenState<DocCreateScreen> {
  late SQDoc newDoc;

  @override
  void initState() {
    String newDocId = widget.collection.getANewDocId();
    newDoc = SQDoc(newDocId, collection: widget.collection);

    for (var field in widget.initialFields) {
      SQDocField? newDocField = newDoc.getFieldByName(field.name);
      newDocField?.value = field.value;
      newDocField?.readOnly = field.readOnly;
    }

    for (var field in newDoc.fields)
      if (field.runtimeType == SQEditedByField)
        field.value = SQUserRefField.currentUserRef;

    super.initState();
  }

  void createDoc() async {
    await widget.collection.createDoc(newDoc).then((_) => exitScreen(context));
  }

  @override
  Widget screenBody(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            ...DocFormField.generateDocFieldsFields(newDoc,
                hiddenFields: widget.hiddenFields),
            SQButton(widget.submitButtonText, onPressed: createDoc)
          ],
        ),
      ),
    );
  }
}
