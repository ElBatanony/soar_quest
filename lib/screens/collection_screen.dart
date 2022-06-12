import 'package:flutter/material.dart';
import 'package:soar_quest/data/sq_collection.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/doc_create_screen.dart';
import 'package:soar_quest/screens/doc_screen.dart';
import 'package:soar_quest/screens/screen.dart';

class CollectionScreen extends Screen {
  final SQCollection collection;
  final Widget Function(SQDoc object)? dataObjectDisplayBody;

  CollectionScreen(String title, this.collection,
      {this.dataObjectDisplayBody, Key? key})
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
    void goToAddItem() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DocCreateScreen("Add item", widget.collection)),
      );
    }

    final itemsDisplay = widget.collection.docs
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
                          )),
                );
              },
            )))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.title} Screen',
            ),
            Text('Object path: ${widget.collection.getPath()}'),
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...itemsDisplay,
                    ElevatedButton(
                        onPressed: goToAddItem, child: Text("Add item"))
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
