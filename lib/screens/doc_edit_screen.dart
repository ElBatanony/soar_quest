import 'package:flutter/material.dart';

import '../app.dart';
import '../components/buttons/sq_button.dart';
import '../data/db.dart';
import 'doc_form_screen.dart';
import 'screen.dart';

class DocEditScreen extends Screen {
  final List<String> shownFields;

  final SQDoc doc;
  DocEditScreen(
    this.doc, {
    super.prebody,
    super.postbody,
    this.shownFields = const [],
    super.key,
  }) : super("Edit ${doc.collection.singleDocName}");

  @override
  State<DocEditScreen> createState() => _DocEditScreenState();
}

class _DocEditScreenState extends ScreenState<DocEditScreen> {
  void updateItem() async {
    await widget.doc.collection.updateDoc(widget.doc).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${widget.doc.collection.singleDocName} updated"),
      ));
      exitScreen(context, value: true);
    });
  }

  @override
  Widget screenBody(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 350),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Doc ID"), Text(widget.doc.id)],
                  ),
                  ...generateDocFieldsFields(widget.doc,
                      shownFields: widget.shownFields),
                  SQButton("Save", onPressed: updateItem)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
