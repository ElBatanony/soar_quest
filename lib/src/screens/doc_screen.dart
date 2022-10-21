import 'package:flutter/material.dart';
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

  Widget fieldDisplay(SQField<dynamic> field, BuildContext context) {
    SQField<dynamic> fieldCopy = field.copy();
    fieldCopy.editable = false;
    return fieldCopy.formField(doc: doc);
  }

  List<Widget> fieldsDisplay(BuildContext context) {
    return doc.fields
        .where((field) => field.show(doc, context))
        .map((field) => fieldDisplay(field, context))
        .toList();
  }

  Widget actionsDisplay(BuildContext context) {
    return Wrap(
      children: collection.actions
          .where((action) => action.show(doc))
          .map((action) => action.button(doc))
          .toList(),
    );
  }

  @override
  Widget screenBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          actionsDisplay(context),
          ...fieldsDisplay(context),
        ],
      ),
    );
  }
}
