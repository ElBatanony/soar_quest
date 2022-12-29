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

  Widget fieldDisplay(SQField<dynamic> field) => field.formField(this);

  List<Widget> fieldsDisplay() => collection.fields
      .where((field) => field.show.check(doc, this))
      .map(fieldDisplay)
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

  StreamSubscription<DocData>? liveListener;

  @override
  void initScreen() {
    if (collection.isLive)
      liveListener = collection.liveUpdates(doc).listen((mapData) {
        doc.parse(mapData);
        refresh();
      });
    super.initScreen();
  }

  @override
  void dispose() {
    if (liveListener != null) unawaited(liveListener?.cancel());
    super.dispose();
  }
}
