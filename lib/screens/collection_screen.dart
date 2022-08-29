import 'package:flutter/material.dart';

import '../app/app_navigator.dart';
import '../data.dart';

import '../components/buttons/col_create_doc_button.dart';
import '../components/buttons/sq_button.dart';

import 'doc_screen.dart';
import 'screen.dart';

class CollectionScreen extends Screen {
  final SQCollection collection;

  CollectionScreen(super.title, {required this.collection, super.key}) {
    collection.screen = this;
  }

  @override
  State<CollectionScreen> createState() => CollectionScreenState();
}

class CollectionScreenState<T extends CollectionScreen> extends ScreenState<T> {
  void refreshScreen() => setState(() {});

  Future loadData() async {
    await widget.collection.loadCollection();
    refreshScreen();
    return;
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Widget docDisplay(SQDoc doc) {
    return SQButton(doc.identifier,
        onPressed: () => goToScreen(
            DocScreen(doc.identifier, doc,
                refreshCollectionScreen: refreshScreen),
            context: context));
  }

  List<Widget> docsDisplay(BuildContext context) {
    return widget.collection.docs.map((doc) => docDisplay(doc)).toList();
  }

  @override
  Widget screenBody(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Collection path: ${widget.collection.getPath()}',
              textAlign: TextAlign.center,
            ),
            ...docsDisplay(context),
            CollectionCreateDocButton(
              widget.collection,
              createCallback: refreshScreen,
            ),
          ],
        ),
      ),
    );
  }
}
