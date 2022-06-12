import 'package:flutter/material.dart';
import 'package:soar_quest/data_objects/data_collection.dart';
import 'package:soar_quest/data_objects/data_object.dart';
import 'package:soar_quest/data_ui/data_collection_display.dart';
import 'package:soar_quest/screens/screen.dart';

class CollectionDisplayScreen extends Screen {
  final DataCollection collection;
  final Widget Function(DataObject object)? dataObjectDisplayBody;

  const CollectionDisplayScreen(String title, this.collection,
      {this.dataObjectDisplayBody, Key? key})
      : super(title, key: key);

  @override
  State<CollectionDisplayScreen> createState() =>
      _CollectionDisplayScreenState();
}

class _CollectionDisplayScreenState extends State<CollectionDisplayScreen> {
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
