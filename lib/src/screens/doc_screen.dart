import 'package:flutter/material.dart';

import '../data/sq_collection.dart';
import 'screen.dart';

class DocScreen extends Screen {
  final SQDoc doc;

  DocScreen(
    this.doc, {
    String? title,
    super.icon,
    super.isInline,
  }) : super(title: title ?? doc.label);

  SQCollection get collection => doc.collection;

  Widget fieldDisplay(SQField<dynamic> field, ScreenState screenState) {
    return field.formField(doc, onChanged: screenState.refreshScreen);
  }

  List<Widget> fieldsDisplay(ScreenState screenState) {
    return doc.fields
        .where((field) => field.show.check(doc, screenState))
        .map((field) => fieldDisplay(field, screenState))
        .toList();
  }

  Widget actionsDisplay(ScreenState screenState) {
    return Wrap(
      children: collection.actions
          .where((action) => action.show.check(doc, screenState))
          .map((action) => action.button(doc, screenState: screenState))
          .toList(),
    );
  }

  @override
  Widget screenBody(ScreenState screenState) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          actionsDisplay(screenState),
          ...fieldsDisplay(screenState),
        ],
      ),
    );
  }
}
