import 'package:flutter/material.dart';

import '../data.dart';
import '../app/app_navigator.dart';

import '../../components/buttons/sq_button.dart';

import 'collection_filter_screen.dart';
import 'collection_screen.dart';

class CategorySelectScreen extends CollectionScreen {
  final SQDocReferenceField categoryField;

  CategorySelectScreen(super.title,
      {required super.collection,
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
        SQDocReferenceField categoryFieldCopy =
            widget.categoryField.copy() as SQDocReferenceField;
        categoryFieldCopy.value = SQDocReference(
          collectionPath: widget.categoryField.collection.getPath(),
          docId: doc.id,
          docIdentifier: doc.identifier,
        );
        print(categoryFieldCopy.name);
        print(categoryFieldCopy.value);
        DocsFilter filter = DocRefFilter(docRefField: categoryFieldCopy);
        goToScreen(
            CollectionFilterScreen("Category of",
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
