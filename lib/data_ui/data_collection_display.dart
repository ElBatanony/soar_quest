import 'package:flutter/material.dart';
import 'package:soar_quest/data_objects/data_collection.dart';
import 'package:soar_quest/data_objects/data_object.dart';
import 'package:soar_quest/screens/collection_insert_screen.dart';
import 'package:soar_quest/screens/data_display_screen.dart';

class CollectionDocDisplay extends StatelessWidget {
  final DataObject docObject;
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
                  builder: (context) =>
                      DataDisplayScreen(docObject.id, docObject)),
            );
          },
        ));
  }
}

class DataCollectionDisplay extends StatefulWidget {
  final DataCollection collection;

  const DataCollectionDisplay(this.collection, {Key? key}) : super(key: key);

  @override
  State<DataCollectionDisplay> createState() => _DataCollectionDisplayState();
}

class _DataCollectionDisplayState extends State<DataCollectionDisplay> {
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
                CollectionInsertScreen("Add item", widget.collection)),
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
