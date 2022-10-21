import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soar_quest/db.dart';

import 'screen.dart';

class DocScreen extends Screen {
  final SQDoc doc;

  DocScreen(
    this.doc, {
    String? title,
    super.prebody,
    super.postbody,
    super.icon,
    super.key,
  }) : super(title ?? doc.label);

  @override
  State<DocScreen> createState() => DocScreenState();
}

class DocScreenState<T extends DocScreen> extends ScreenState<T> {
  SQDoc get doc => widget.doc;
  SQCollection get collection => doc.collection;

  void loadData() async {
    await collection.ensureInitialized(doc);
    refreshScreen();
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Widget fieldDisplay(SQField<dynamic> field) {
    SQField<dynamic> fieldCopy = field.copy();
    fieldCopy.editable = false;
    return GestureDetector(
      onLongPress: () {
        String fieldValue = fieldCopy.value.toString();
        Clipboard.setData(ClipboardData(text: fieldValue));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 500),
            content: Text('Copied field: $fieldValue')));
      },
      child: fieldCopy.formField(doc: doc),
    );
  }

  List<Widget> fieldsDisplay(BuildContext inScreenContext) {
    return doc.fields
        .where((field) => field.show(doc, inScreenContext))
        .map((field) => fieldDisplay(field))
        .toList();
  }

  Widget actionsDisplay() {
    return Wrap(
      children: collection.actions.map((action) => action.button(doc)).toList(),
    );
  }

  @override
  Widget screenBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          actionsDisplay(),
          ...fieldsDisplay(context),
        ],
      ),
    );
  }
}
