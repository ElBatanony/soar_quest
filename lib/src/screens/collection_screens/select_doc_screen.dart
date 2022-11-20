import 'package:flutter/material.dart';

import '../../db/sq_doc.dart';
import '../../ui/sq_button.dart';

import '../collection_screen.dart';

class SelectDocScreen extends CollectionScreen {
  SelectDocScreen({String? title, required super.collection, super.key})
      : super(title: title ?? "Select ${collection.id}");

  @override
  Widget docDisplay(SQDoc doc, ScreenState screenState) {
    return SQButton(doc.label,
        onPressed: () => screenState.exitScreen<SQDoc>(doc));
  }
}
