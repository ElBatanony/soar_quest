import 'package:flutter/material.dart';
import 'package:soar_quest/data/sq_collection.dart';
import 'package:soar_quest/screens/doc_create_screen.dart';

class CollectionCreateDocButton extends StatelessWidget {
  final SQCollection collection;

  const CollectionCreateDocButton(this.collection, {Key? key})
      : super(key: key);

  void goToCreateScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DocCreateScreen("Add item", collection)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
          onPressed: () => goToCreateScreen(context),
          child: Text("Create ${collection.singleDocName}")),
    );
  }
}
