import 'package:flutter/material.dart';

import '../../../app.dart';

import '../../components/buttons/sq_button.dart';

import '../../../db.dart';
import '../collection_screen.dart';

class CategorySelectScreen extends CollectionScreen {
  final SQDocRefField categoryField;

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
  Future loadData() async {
    await widget.categoryField.collection.loadCollection();
    refreshScreen();
  }

  @override
  Widget docDisplay(SQDoc doc) {
    return SQButton(
      doc.identifier,
      onPressed: () {
        SQDocRefField categoryFieldCopy = widget.categoryField.copy();
        categoryFieldCopy.value = SQDocRef(
          collectionPath: widget.categoryField.collection.getPath(),
          docId: doc.id,
          docIdentifier: doc.identifier,
        );
        print(categoryFieldCopy.name);
        print(categoryFieldCopy.value);
        CollectionFilter filter =
            DocRefFieldFilter(docRefField: categoryFieldCopy);
        goToScreen(
            CollectionFilterScreen(
                title: "Category of",
                collection: widget.collection,
                filters: [filter],
                docScreen: widget.docScreen),
            context: context);
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
