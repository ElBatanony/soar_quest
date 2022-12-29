import 'dart:async';

import 'package:flutter/material.dart';

import '../data/sq_collection.dart';
import 'screen.dart';

class DocScreen extends Screen {
  DocScreen(
    this.doc, {
    String? title,
    super.icon,
  }) : super(title ?? doc.label);

  final SQDoc doc;

  SQCollection get collection => doc.collection;

  @override
  createState() => DocScreenState();

  Widget fieldDisplay(SQField<dynamic> field, ScreenState screenState) =>
      field.formField(screenState as DocScreenState);

  List<Widget> fieldsDisplay(ScreenState screenState) => collection.fields
      .where((field) => field.show.check(doc, screenState))
      .map((field) => fieldDisplay(field, screenState))
      .toList();

  Widget actionsDisplay() => Wrap(
        children: collection.actions
            .where((action) => action.show.check(doc, this))
            .map((action) => action.button(doc, screen: this))
            .toList(),
      );

  @override
  Widget screenBody() => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            actionsDisplay(),
            ...fieldsDisplay(),
          ],
        ),
      );
}

class DocScreenState<DS extends DocScreen> extends ScreenState<DS> {
  SQDoc get doc => widget.doc;
  SQCollection get collection => doc.collection;

  StreamSubscription<DocData>? liveListener;

  @override
  void initState() {
    if (collection.isLive)
      liveListener = collection.liveUpdates(doc).listen((mapData) {
        doc.parse(mapData);
        refresh();
      });
    super.initState();
  }

  @override
  void dispose() {
    if (liveListener != null) unawaited(liveListener?.cancel());
    super.dispose();
  }
}
