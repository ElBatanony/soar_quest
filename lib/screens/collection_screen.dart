import 'package:flutter/material.dart';

import '../app/app_navigator.dart';
import '../data.dart';

import '../components/buttons/sq_button.dart';

import 'doc_create_screen.dart';
import 'doc_screen.dart';
import 'screen.dart';

DocScreen defaultDocScreen(SQDoc doc) => DocScreen(doc);

class CollectionScreen extends Screen {
  final SQCollection collection;
  final DocScreen Function(SQDoc doc) docScreen;

  CollectionScreen(
      {String? title,
      required this.collection,
      this.docScreen = defaultDocScreen,
      super.prebody,
      super.postbody,
      super.key})
      : super(title ?? collection.id) {
    collection.screen = this;
  }

  @override
  State<CollectionScreen> createState() => CollectionScreenState();
}

class CollectionScreenState<T extends CollectionScreen> extends ScreenState<T> {
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

  Future goToDocScreen(DocScreen docScreen) async {
    await goToScreen(docScreen, context: context);
    refreshScreen();
  }

  DocScreen docScreen(SQDoc doc) => widget.docScreen(doc);

  Widget docDisplay(SQDoc doc) {
    return SQButton(
      doc.identifier,
      onPressed: () => goToDocScreen(docScreen(doc)),
    );
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
            ...docsDisplay(context),
            if (widget.collection.readOnly == false)
              SQButton(
                "Create ${widget.collection.singleDocName}",
                onPressed: () async {
                  await goToScreen(DocCreateScreen(widget.collection),
                      context: context);
                  loadData();
                },
              ),
          ],
        ),
      ),
    );
  }
}
