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
  late SQDoc doc;

  void loadData() async {
    await doc.loadDoc();
    refreshScreen();
  }

  @override
  void initState() {
    doc = widget.doc;
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
          Text('Doc path: ${doc.getPath()}', textAlign: TextAlign.center),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  doc.fields.map((field) => Text(field.toString())).toList()),
          if (doc.collection.readOnly == false)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DocEditButton(doc, refresh: refreshScreen),
                if (doc.collection.canDeleteDoc)
                  DocDeleteButton(doc, deleteCallback: refreshScreen)
              ],
            ),
        ],
      ),
    );
  }
}
