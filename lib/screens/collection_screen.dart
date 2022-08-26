import 'package:flutter/material.dart';

import '../app/app_navigator.dart';
import '../data.dart';

import '../components/buttons/col_create_doc_button.dart';
import '../components/buttons/sq_button.dart';

import 'doc_screen.dart';
import 'screen.dart';

class CollectionScreen extends Screen {
  final SQCollection collection;

  final Widget Function(SQCollection collection,
      {required Function refreshScreen, Key? key}) collectionScreenBody;

  final DocScreenBody Function(SQDoc doc) docScreenBody;

  CollectionScreen(String title,
      {required this.collection,
      this.docScreenBody = DocScreenBody.new,
      this.collectionScreenBody = CollectionScreenBody.new,
      Key? key})
      : super(title, key: key) {
    collection.screen = this;
  }

  @override
  State<CollectionScreen> createState() => CollectionScreenState();
}

class CollectionScreenState<T extends CollectionScreen> extends State<T> {
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
    return Text("Doc: ${doc.identifier}");
  }

  List<Widget> docsDisplay(BuildContext context) {
    return widget.collection.docs.map((doc) => docDisplay(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: widget.collectionScreenBody(
          widget.collection,
          refreshScreen: refreshScreen,
        ));
  }
}

class CollectionScreenBody extends StatefulWidget {
  final SQCollection collection;
  final Function refreshScreen;
  const CollectionScreenBody(this.collection,
      {required this.refreshScreen, Key? key})
      : super(key: key);

  @override
  State<CollectionScreenBody> createState() => _CollectionScreenBodyState();
}

class _CollectionScreenBodyState extends State<CollectionScreenBody> {
  @override
  Widget build(BuildContext context) {
    var itemsDisplay = widget.collection.docs
        .map((doc) => CollectionScreenDocButton(
            doc, widget.collection, widget.refreshScreen))
        .toList();

    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Object path: ${widget.collection.getPath()}',
              textAlign: TextAlign.center,
            ),
            ...itemsDisplay,
            CollectionCreateDocButton(
              widget.collection,
              createCallback: widget.refreshScreen,
            ),
          ],
        ),
      ),
    );
  }
}

class CollectionScreenDocButton extends StatelessWidget {
  final SQDoc doc;
  final Function refreshScreen;
  final SQCollection collection;
  const CollectionScreenDocButton(this.doc, this.collection, this.refreshScreen,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SQButton(doc.identifier,
        onPressed: () => goToScreen(
            DocScreen(doc.id, doc, refreshCollectionScreen: refreshScreen),
            context: context));
  }
}
