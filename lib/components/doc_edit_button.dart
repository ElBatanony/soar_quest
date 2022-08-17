import 'package:flutter/material.dart';
import 'package:soar_quest/app/app_navigator.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/doc_edit_screen.dart';

class DocEditButton extends StatelessWidget {
  final SQDoc doc;
  final Function refresh;

  const DocEditButton(this.doc, {required this.refresh, Key? key})
      : super(key: key);

  void goToEditScreen(BuildContext context) async {
    await goToScreen(DocEditScreen("Edit ${doc.collection.singleDocName}", doc),
        context: context);
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => goToEditScreen(context),
      child: Text("Edit ${doc.collection.singleDocName}"),
    );
  }
}
