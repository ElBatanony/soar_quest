import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../db/sq_doc.dart';
import '../ui/sq_button.dart';

import '../ui/doc_delete_button.dart';

import 'form_screens/doc_edit_screen.dart';
import 'screen.dart';

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
  }) : super(doc.identifier);

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
      child: field.readOnlyField(doc: doc),
    );
  }

  @override
  Widget screenBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...doc.fields.map(fieldDisplay).toList(),
        if (doc.collection.readOnly == false)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (widget.canEdit)
                SQButton(
                  "Edit ${doc.collection.singleDocName}",
                  onPressed: () async {
                    await goToScreen(docEditScreen(doc), context: context);
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
