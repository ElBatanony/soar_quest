import 'package:flutter/material.dart';
import 'package:soar_quest/data/sq_doc.dart';

class DocDeleteButton extends StatelessWidget {
  final SQDoc doc;
  final bool popAfterDelete;

  const DocDeleteButton(this.doc, {this.popAfterDelete = true, Key? key})
      : super(key: key);

  void deleteDoc(BuildContext context) {
    doc.collection.deleteDoc(doc.id).then((_) {
      doc.collection.refreshUI!();
      if (popAfterDelete) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => deleteDoc(context),
        child: Text("Delete ${doc.collection.singleDocName}"));
  }
}
