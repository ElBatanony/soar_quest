import 'package:flutter/material.dart';
import 'package:soar_quest/data/sq_collection.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/doc_create_screen.dart';
import 'package:soar_quest/screens/doc_screen.dart';
import 'package:soar_quest/screens/screen.dart';

class CollectionScreen extends Screen {
  final SQCollection collection;

  final Widget Function(SQCollection collection,
      {required Function refreshScreen, Key? key}) collectionScreenBody;

  final Widget Function(SQDoc object) docScreenBody;

  CollectionScreen(String title, this.collection,
      {this.docScreenBody = DefaultDocScreenBody.new,
      this.collectionScreenBody = DefaultCollectionScreenBody.new,
      Key? key})
      : super(title, key: key) {
    collection.screen = this;
  }

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  void loadData() async {
    await widget.collection.loadCollection();
    setState(() {});
  }

  void refreshScreen() {
    setState(() {});
  }

  @override
  void initState() {
    widget.collection.refreshUI = refreshScreen;
    loadData();
    super.initState();
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

class DefaultCollectionScreenBody extends StatelessWidget {
  final SQCollection collection;
  final Function refreshScreen;
  const DefaultCollectionScreenBody(this.collection,
      {required this.refreshScreen, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void goToAddItem() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DocCreateScreen("Add item", collection)),
      );
    }

    final itemsDisplay = collection.docs
        .map((doc) => Container(
            padding: EdgeInsets.all(8),
            child: ElevatedButton(
              child: Text(doc.id),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DocScreen(
                            doc.id,
                            doc,
                            refreshCollectionScreen: refreshScreen,
                            docScreenBody: collection.screen!.docScreenBody,
                          )),
                );
              },
            )))
        .toList();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Object path: ${collection.getPath()}'),
          Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ...itemsDisplay,
              ElevatedButton(onPressed: goToAddItem, child: Text("Add item"))
            ]),
          ),
        ],
      ),
    );
  }
}
