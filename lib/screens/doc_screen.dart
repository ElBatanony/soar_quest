import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data.dart';

import '../components/buttons/doc_delete_button.dart';
import '../components/buttons/doc_edit_button.dart';

import 'screen.dart';

class DocScreen extends Screen {
  final SQDoc doc;

  DocScreen(this.doc, {super.prebody, super.postbody, super.key})
      : super(doc.identifier);

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

  Widget fieldDisplay(SQDocField field) {
    return GestureDetector(
      onLongPress: () {
        String fieldValue = field.value.toString();
        Clipboard.setData(ClipboardData(text: fieldValue));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 500),
            content: Text('Copied field: $fieldValue')));
      },
      child: Text(field.toString()),
    );
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
              children: doc.fields.map(fieldDisplay).toList()),
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
