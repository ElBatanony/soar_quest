import 'package:flutter/material.dart';
import 'package:soar_quest/data/sq_collection.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/doc_create_screen.dart';
import 'package:soar_quest/screens/doc_screen.dart';
import 'package:soar_quest/screens/screen.dart';

class CollectionScreen extends Screen {
  final SQCollection collection;
  final Widget Function(SQDoc object)? dataObjectDisplayBody;

  const CollectionScreen(String title, this.collection,
      {this.dataObjectDisplayBody, Key? key})
      : super(title, key: key);

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  void loadData() async {
    await widget.collection.loadCollection();
    setState(() {});
  }

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    widget.collection.updateUI = refresh;
    widget.collection.diplayScreen = widget;
    loadData();
    super.initState();
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
          children: [
            Text(
              '${widget.title} Screen',
            ),
            Text('Object path: ${widget.collection.collectionPath}'),
            CollectionDisplay(widget.collection)
          ],
        ),
      ),
    );
  }
}

class CollectionDocDisplay extends StatelessWidget {
  final SQDoc docObject;
  const CollectionDocDisplay(this.docObject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: ElevatedButton(
          child: Text(docObject.id),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DocScreen(docObject.id, docObject)),
            );
          },
        ));
  }
}

class CollectionDisplay extends StatefulWidget {
  final SQCollection collection;

  const CollectionDisplay(this.collection, {Key? key}) : super(key: key);

  @override
  State<CollectionDisplay> createState() => _CollectionDisplayState();
}

class _CollectionDisplayState extends State<CollectionDisplay> {
  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    // widget.collection.updateUI = refresh;
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

    final itemsDisplay =
        widget.collection.docs.map((doc) => CollectionDocDisplay(doc)).toList();

    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ...itemsDisplay,
        ElevatedButton(onPressed: goToAddItem, child: Text("Add item"))
      ]),
    );
  }
}
