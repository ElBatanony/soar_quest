import 'package:flutter/material.dart';

import '../../db/sq_collection.dart';
import '../../db/fields/sq_ref_field.dart';
import '../../ui/sq_button.dart';

import '../collection_screen.dart';
import 'collection_filter_screen.dart';

class CategorySelectScreen extends CollectionScreen {
  final SQRefField categoryField;

  CategorySelectScreen(
      {super.title,
      required super.collection,
      required this.categoryField,
      super.docScreen,
      super.key});

  @override
  State<CategorySelectScreen> createState() => _CategorySelectScreenState();
}

class _CategorySelectScreenState
    extends CollectionScreenState<CategorySelectScreen> {
  @override
  Future<void> loadData() async {
    await widget.categoryField.collection.loadCollection();
    refreshScreen();
  }

  @override
  Widget docDisplay(SQDoc doc) {
    return SQButton(
      doc.label,
      onPressed: () {
        SQRefField categoryFieldCopy = widget.categoryField.copy();
        categoryFieldCopy.value = SQRef(
          collectionPath: widget.categoryField.collection.path,
          docId: doc.id,
          label: doc.label,
        );
        print(categoryFieldCopy.name);
        print(categoryFieldCopy.value);
        CollectionFilter filter =
            DocRefFieldFilter(docRefField: categoryFieldCopy);
        CollectionFilterScreen(
                title: "Category of",
                collection: widget.collection,
                filters: [filter],
                docScreen: widget.docScreen)
            .go(context);
      },
    );
  }

  @override
  List<Widget> docsDisplay(BuildContext context) {
    return widget.categoryField.collection.docs
        .map((doc) => docDisplay(doc))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: docsDisplay(context),
        ),
      ),
    );
  }
}
