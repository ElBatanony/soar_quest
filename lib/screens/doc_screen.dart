import 'package:flutter/material.dart';
import 'package:soar_quest/components/doc_delete_button.dart';
import 'package:soar_quest/components/doc_edit_button.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/screen.dart';

class DocScreen extends Screen {
  final SQDoc doc;
  final Function refreshCollectionScreen;

  DocScreen(String title, this.doc,
      {required this.refreshCollectionScreen, Key? key})
      : super(title, key: key);

  @override
  State<DocScreen> createState() => _DocScreenState();
}

class _DocScreenState extends State<DocScreen> {
  late SQDoc doc;

  void loadData() async {
    if (widget.doc.initialized == false)
      doc = await widget.doc.collection.loadDoc(widget.doc);
    else
      doc = widget.doc;

    setState(() {});
  }

  void refresh() {
    setState(() {});
  }

  void deleteCallback() {
    widget.refreshCollectionScreen();
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
        title: Text(doc.identifier),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.title} Screen',
            ),
            Text(
              'Object path: ${doc.getPath()}',
              textAlign: TextAlign.center,
            ),
            doc.collection.screen!.docScreenBody(doc),
            DocEditButton(doc, refresh: refresh),
            DocDeleteButton(doc, deleteCallback: deleteCallback)
          ],
        ),
      ),
    );
  }
}

class DocFieldDisplay extends StatelessWidget {
  final SQDocField field;
  const DocFieldDisplay(this.field, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(field.toString());
  }
}

class DocScreenBody extends StatefulWidget {
  final SQDoc doc;
  const DocScreenBody(this.doc, {Key? key}) : super(key: key);

  @override
  State<DocScreenBody> createState() => _DocScreenBodyState();
}

class _DocScreenBodyState extends State<DocScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.doc.fields
              .map((field) => DocFieldDisplay(field))
              .toList()),
    );
  }
}
