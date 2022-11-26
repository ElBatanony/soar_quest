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

class DocScreenState extends ScreenState<DocScreen> {
  late final StreamSubscription<SQDoc>? liveListener;

  @override
  void initState() {
    if (widget.collection.isLive)
      liveListener = widget.collection.liveUpdates(widget.doc).listen((event) {
        widget.doc.parse(event.serialize());
        refreshScreen();
      });
    super.initState();
  }

  @override
  void dispose() {
    unawaited(liveListener?.cancel());
    super.dispose();
  }
}
