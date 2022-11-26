import 'dart:async';

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

  @override
  createState() => DocScreenState();

  Widget fieldDisplay(SQField<dynamic> field, ScreenState screenState) =>
      field.formField(
          screenState as DocScreenState); // TODO: make ScreenState generic

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

class DocScreenState<DS extends DocScreen> extends ScreenState<DS> {
  SQDoc get doc => widget.doc;
  SQCollection get collection => doc.collection;

  StreamSubscription<DocData>? liveListener;

  @override
  void initState() {
    if (widget.collection.isLive)
      liveListener =
          widget.collection.liveUpdates(widget.doc).listen((mapData) {
        widget.doc.parse(mapData);
        refreshScreen();
      });
    super.initState();
  }

  @override
  void dispose() {
    if (liveListener != null) unawaited(liveListener?.cancel());
    super.dispose();
  }
}
