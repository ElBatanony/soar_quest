import 'package:flutter/material.dart';

import '../data.dart';

import '../components/buttons/doc_delete_button.dart';
import '../components/buttons/doc_edit_button.dart';

import 'screen.dart';

class DocScreen extends Screen {
  final SQDoc doc;

  DocScreen(this.doc, {super.key}) : super(doc.identifier);

  @override
  State<DocScreen> createState() => DocScreenState();
}

class DocScreenState<T extends DocScreen> extends ScreenState<T> {
  void loadData() async {
    await widget.doc.loadDoc();
    setState(() {});
  }

  @override
  void refreshScreen() {
    setState(() {});
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget screenBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Doc path: ${widget.doc.getPath()}',
              textAlign: TextAlign.center),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.doc.fields
                  .map((field) => Text(field.toString()))
                  .toList()),
          if (widget.doc.collection.readOnly == false)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DocEditButton(widget.doc, refresh: refreshScreen),
                if (widget.doc.collection.canDeleteDoc)
                  DocDeleteButton(widget.doc, deleteCallback: refreshScreen)
              ],
            ),
        ],
      ),
    );
  }
}
