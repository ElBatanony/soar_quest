import 'package:flutter/material.dart';

import '../db/sq_collection.dart';
import 'screen.dart';

class DocScreen extends Screen {
  final SQDoc doc;

  DocScreen(
    this.doc, {
    String? title,
    super.icon,
    super.isInline,
    super.key,
  }) : super(title ?? doc.label);

  @override
  State<DocScreen> createState() => DocScreenState();
}

class DocScreenState<T extends DocScreen> extends ScreenState<T> {
  SQDoc get doc => widget.doc;
  SQCollection get collection => doc.collection;

  Widget fieldDisplay(SQField<dynamic> field, BuildContext context) {
    return field.formField(doc, onChanged: refreshScreen);
  }

  List<Widget> fieldsDisplay(BuildContext context) {
    return doc.fields
        .where((field) => field.show.check(doc, context))
        .map((field) => fieldDisplay(field, context))
        .toList();
  }

  Widget actionsDisplay(BuildContext context) {
    return Wrap(
      children: collection.actions
          .where((action) => action.show.check(doc, context))
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
