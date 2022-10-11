import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../db/sq_doc.dart';
import '../ui/sq_button.dart';

import '../ui/doc_delete_button.dart';

import 'screen.dart';
import 'form_screen.dart';

class DocScreen extends Screen {
  final SQDoc doc;
  final bool canEdit, canDelete;

  DocScreen(
    this.doc, {
    super.prebody,
    super.postbody,
    this.canEdit = true,
    this.canDelete = true,
    super.icon,
    super.key,
  }) : super(doc.label);

  @override
  State<DocScreen> createState() => DocScreenState();
}

class DocScreenState<T extends DocScreen> extends ScreenState<T> {
  late SQDoc doc;

  void loadData() async {
    await doc.collection.loadDoc(doc);
    refreshScreen();
  }

  @override
  void initState() {
    doc = widget.doc;
    loadData();
    super.initState();
  }

  Widget fieldDisplay(SQField field) {
    field.readOnly = true;
    return GestureDetector(
      onLongPress: () {
        String fieldValue = field.value.toString();
        Clipboard.setData(ClipboardData(text: fieldValue));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 500),
            content: Text('Copied field: $fieldValue')));
      },
      child: field.formField(doc: doc),
    );
  }

  @override
  Widget screenBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
            children: doc.collection.actions
                .map((action) => SQButton(action.name,
                    onPressed: () => action.execute(doc, context)))
                .toList()),
        ...doc.fields.map((field) => fieldDisplay(field.copy())).toList(),
        if (doc.collection.readOnly == false)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (widget.canEdit)
                SQButton(
                  "Edit ${doc.collection.singleDocName}",
                  onPressed: () async {
                    await FormScreen(doc).go(context);
                    refreshScreen();
                  },
                ),
              if (doc.collection.canDeleteDoc && widget.canDelete)
                DocDeleteButton(doc, deleteCallback: refreshScreen)
            ],
          ),
      ],
    );
  }
}
