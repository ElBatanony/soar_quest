import 'package:flutter/material.dart';
import 'package:soar_quest/data_objects/sq_collection.dart';
import 'package:soar_quest/data_objects/sq_doc.dart';
import 'package:soar_quest/data_ui/data_collection_display.dart';
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
            DataCollectionDisplay(widget.collection)
          ],
        ),
      ),
    );
  }
}
