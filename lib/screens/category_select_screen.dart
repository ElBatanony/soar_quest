import 'package:flutter/material.dart';
import 'package:soar_quest/app/app_navigator.dart';
import 'package:soar_quest/data/docs_filter.dart';
import 'package:soar_quest/data/sq_collection.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/collection_filter_screen.dart';

import 'collection_screen.dart';

class CategorySelectScreen extends CollectionScreen {
  final SQCollection categoryCollection;
  final SQDocField categoryField;

  CategorySelectScreen(super.title,
      {required super.collection,
      required this.categoryCollection,
      required this.categoryField,
      super.key});

  @override
  State<CategorySelectScreen> createState() => _CategorySelectScreenState();
}

class _CategorySelectScreenState
    extends CollectionScreenState<CategorySelectScreen> {
  @override
  Future loadData() async {
    await widget.categoryCollection.loadCollection();
    refreshScreen();
  }

  List<Widget> docsDisplay(BuildContext context) {
    return widget.categoryCollection.docs.map((doc) {
      return Container(
          padding: EdgeInsets.all(8),
          child: ElevatedButton(
            child: Text(doc.identifier),
            onPressed: () {
              SQDocField categoryFieldCopy = widget.categoryField.copy();
              categoryFieldCopy.value = doc.identifier;
              DocsFilter filter = DocsFilter(categoryFieldCopy);
              goToScreen(
                  CollectionFilterScreen("Category of ",
                      collection: widget.collection, filters: [filter]),
                  context: context);
            },
          ));
    }).toList();
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
