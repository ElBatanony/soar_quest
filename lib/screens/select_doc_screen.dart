import 'package:flutter/material.dart';
import 'package:soar_quest/components/sq_button.dart';

import '../data.dart';
import 'collection_screen.dart';

class SelectDocScreen extends CollectionScreen {
  SelectDocScreen(String title, {required SQCollection collection, Key? key})
      : super(title, collection, key: key);

  @override
  State<SelectDocScreen> createState() => _SelectDocScreenState();
}

class _SelectDocScreenState extends State<SelectDocScreen> {
  void loadData() async {
    await widget.collection.loadCollection();
    refreshScreen();
    updateDocs();
  }

  void refreshScreen() {
    setState(() {});
  }

  @override
  void initState() {
    loadData();

    super.initState();
  }

  void updateDocs() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var itemsDisplay = widget.collection.docs
        .map((doc) => SQButton(doc.identifier, onPressed: () {
              Navigator.pop<SQDoc>(context, doc);
            }))
        .toList();

    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.title} ${widget.collection.id}"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: itemsDisplay,
            ),
          ),
        ));
  }
}
