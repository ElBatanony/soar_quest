import 'package:flutter/material.dart';
import 'package:soar_quest/data/sq_doc.dart';

class DocDeleteButton extends StatelessWidget {
  final SQDoc doc;

  const DocDeleteButton(this.doc, {Key? key}) : super(key: key);

  void deleteDoc(BuildContext context) {
    doc.collection.deleteDoc(doc.id).then((_) {
      doc.collection.refreshUI!();
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => deleteDoc(context), child: Text("Delete Doc"));
  }
}
