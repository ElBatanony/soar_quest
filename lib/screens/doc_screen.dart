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

class DocScreenState<T extends DocScreen> extends ScreenState<T> {
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
  Widget screenBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Doc path: ${widget.doc.getPath()}', textAlign: TextAlign.center),
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.doc.fields
                .map((field) => Text(field.toString()))
                .toList()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DocEditButton(widget.doc, refresh: refresh),
            DocDeleteButton(widget.doc, deleteCallback: deleteCallback)
          ],
        ),
      ],
    );
  }
}
