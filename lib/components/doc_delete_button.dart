import 'package:flutter/material.dart';
import 'package:soar_quest/data/sq_doc.dart';

class DocDeleteButton extends StatelessWidget {
  final SQDoc doc;
  final bool popAfterDelete;
  final bool isIcon;
  final Function? deleteCallback;

  const DocDeleteButton(this.doc,
      {this.popAfterDelete = true,
      this.isIcon = false,
      this.deleteCallback,
      Key? key})
      : super(key: key);

  void deleteDoc(BuildContext context) {
    doc.collection.deleteDoc(doc.id).then((_) {
      if (deleteCallback != null) deleteCallback!();
      if (popAfterDelete) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isIcon)
      return IconButton(
          onPressed: () => deleteDoc(context), icon: Icon(Icons.delete));

    return ElevatedButton(
        onPressed: () => deleteDoc(context),
        child: Text("Delete ${doc.collection.singleDocName}"));
  }
}
