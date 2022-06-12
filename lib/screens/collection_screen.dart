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

  final DocScreenBody Function(SQDoc doc) docScreenBody;

  CollectionScreen(String title, this.collection,
      {this.docScreenBody = DocScreenBody.new,
      this.collectionScreenBody = CollectionScreenBody.new,
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
    refreshScreen();
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
    void goToAddItem() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DocCreateScreen("Add item", widget.collection)),
      );
    }

    var itemsDisplay = widget.collection.docs
        .map((doc) => CollectionScreenBodyDocButton(
            doc, widget.collection, widget.refreshScreen))
        .toList();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Object path: ${widget.collection.getPath()}',
            textAlign: TextAlign.center,
          ),
          ...itemsDisplay,
          ElevatedButton(onPressed: goToAddItem, child: Text("Add item")),
        ],
      ),
    );
  }
}

class CollectionScreenBodyDocButton extends StatelessWidget {
  final SQDoc doc;
  final Function refreshScreen;
  final SQCollection collection;
  const CollectionScreenBodyDocButton(
      this.doc, this.collection, this.refreshScreen,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: ElevatedButton(
          child: Text(doc.identifier),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DocScreen(doc.id, doc,
                      refreshCollectionScreen: refreshScreen)),
            );
          },
        ));
  }
}
