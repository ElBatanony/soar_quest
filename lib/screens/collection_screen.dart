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
    return CollectionScreenDocButton(doc, widget.collection, refreshScreen);
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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Object path: ${widget.collection.getPath()}',
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
        ));
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
