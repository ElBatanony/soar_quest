import 'package:flutter/material.dart';
import 'package:soar_quest/data_objects/sq_collection.dart';
import 'package:soar_quest/data_objects/sq_doc.dart';
import 'package:soar_quest/data_ui/data_insert_display.dart';
import 'package:soar_quest/screens/screen.dart';

class CollectionInsertScreen extends Screen {
  final SQCollection collection;
  const CollectionInsertScreen(String title, this.collection, {Key? key})
      : super(title, key: key);

  @override
  State<CollectionInsertScreen> createState() => _CollectionInsertScreenState();
}

class _CollectionInsertScreenState extends State<CollectionInsertScreen> {
  void loadData() async {
    await widget.collection.loadCollection();
    setState(() {});
  }

  @override
  void initState() {
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
            DataObjectInsertDisplay(SQDoc(
                "new-id", widget.collection.fields, "new-id",
                userData: widget.collection.userData,
                collection: widget.collection))
          ],
        ),
      ),
    );
  }
}
