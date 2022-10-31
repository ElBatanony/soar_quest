import 'package:flutter/material.dart';

import '../../db/collection_slice.dart';
import '../../db/fields/sq_ref_field.dart';
import '../../db/sq_collection.dart';
import '../collection_screen.dart';
import '../screen.dart';
import 'gallery_screen.dart';

class CategorySelectScreen extends GalleryScreen {
  final SQRefField categoryField;

  CategorySelectScreen({
    super.title,
    required super.collection,
    required this.categoryField,
  });

  @override
  State<CategorySelectScreen> createState() => _CategorySelectScreenState();
}

class _CategorySelectScreenState
    extends GalleryScreenState<CategorySelectScreen> {
  @override
  SQCollection<SQDoc> get collection => widget.categoryField.collection;

  @override
  Screen docScreen(SQDoc doc) {
    final slice = CollectionSlice(widget.collection,
        filter: RefFilter(widget.categoryField.name, doc.ref));
    return CollectionScreen(
        title: "${doc.label} ${widget.collection.id}", collection: slice);
  }
}
