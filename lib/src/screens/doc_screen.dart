import 'package:flutter/material.dart';

import '../data/sq_collection.dart';
import 'screen.dart';

class DocScreen extends Screen {
  DocScreen(
    this.doc, {
    String? title,
    super.icon,
    super.isInline,
  }) : super(title: title ?? doc.label);

  final SQDoc doc;

  SQCollection get collection => doc.collection;

  Widget fieldDisplay(SQField<dynamic> field, ScreenState screenState) =>
      field.formField(doc, onChanged: screenState.refreshScreen);

  List<Widget> fieldsDisplay(ScreenState screenState) => doc.fields
      .where((field) => field.show.check(doc, screenState))
      .map((field) => fieldDisplay(field, screenState))
      .toList();

  Widget actionsDisplay(ScreenState screenState) => Wrap(
        children: collection.actions
            .where((action) => action.show.check(doc, screenState))
            .map((action) => action.button(doc, screenState: screenState))
            .toList(),
      );

  @override
  Widget screenBody(ScreenState screenState) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            actionsDisplay(screenState),
            ...fieldsDisplay(screenState),
          ],
        ),
      );
}
