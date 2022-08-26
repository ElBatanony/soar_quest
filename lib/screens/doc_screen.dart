import 'package:flutter/material.dart';

import '../data.dart';

import '../components/buttons/doc_delete_button.dart';
import '../components/buttons/doc_edit_button.dart';

import 'screen.dart';

class DocScreen extends Screen {
  final SQDoc doc;
  final Function refreshCollectionScreen;

  DocScreen(super.title, this.doc,
      {required this.refreshCollectionScreen, super.key});

  @override
  State<DocScreen> createState() => DocScreenState();
}

class DocScreenState<T extends DocScreen> extends State<T> {
  void loadData() async {
    await widget.doc.loadDoc();

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
        title: Text(widget.doc.identifier),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.title} Screen',
            ),
            Text(
              'Object path: ${widget.doc.getPath()}',
              textAlign: TextAlign.center,
            ),
            widget.doc.collection.screen!.docScreenBody(widget.doc),
            DocEditButton(widget.doc, refresh: refresh),
            DocDeleteButton(widget.doc, deleteCallback: deleteCallback)
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
