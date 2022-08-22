import 'package:flutter/material.dart';
import 'package:soar_quest/app/app_navigator.dart';
import 'package:soar_quest/data/sq_collection.dart';
import 'package:soar_quest/screens/doc_create_screen.dart';

class CollectionCreateDocButton extends StatelessWidget {
  final SQCollection collection;
  final Function? createCallback;

  const CollectionCreateDocButton(this.collection,
      {this.createCallback, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
          onPressed: () => goToScreen(
              DocCreateScreen(
                "Create ${collection.singleDocName}",
                collection,
                createCallback: createCallback,
              ),
              context: context),
          child: Text("Create ${collection.singleDocName}")),
    );
  }
}
