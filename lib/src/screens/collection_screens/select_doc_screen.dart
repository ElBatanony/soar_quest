import 'package:flutter/material.dart';

import '../../data/sq_doc.dart';
import '../../ui/button.dart';

import '../collection_screen.dart';

class SelectDocScreen extends CollectionScreen {
  SelectDocScreen({required super.collection, String? title})
      : super(title: title ?? 'Select ${collection.id}');

  @override
  Widget docDisplay(doc) =>
      SQButton(doc.label, onPressed: () => exitScreen<SQDoc>(doc));
}
