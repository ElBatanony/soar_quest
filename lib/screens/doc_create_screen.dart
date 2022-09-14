import 'package:flutter/material.dart';

import '../../data.dart';
import '../app/app_navigator.dart';
import '../components/buttons/sq_button.dart';
import '../components/doc_field_field.dart';
import 'screen.dart';

class DocCreateScreen extends Screen {
  final SQCollection collection;
  final List<SQDocField> initialFields;
  final List<String> hiddenFields;

  DocCreateScreen(
    this.collection, {
    this.initialFields = const [],
    this.hiddenFields = const [],
    super.key,
  }) : super("Create ${collection.singleDocName}");

  @override
  State<DocCreateScreen> createState() => _DocCreateScreenState();
}

class _DocCreateScreenState extends ScreenState<DocCreateScreen> {
  late SQDoc newDoc;

  @override
  void initState() {
    String newDocId = widget.collection.getANewDocId();
    newDoc = SQDoc(newDocId, collection: widget.collection);

    for (var field in widget.initialFields)
      newDoc.getFieldByName(field.name).value = field.value;

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
            ...DocFieldField.generateDocFieldsFields(newDoc,
                hiddenFields: widget.hiddenFields),
            SQButton("Create", onPressed: createDoc)
          ],
        ),
      ),
    );
  }
}
