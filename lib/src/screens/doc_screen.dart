import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../db/sq_collection.dart';
import '../ui/sq_button.dart';

import 'screen.dart';
import 'form_screen.dart';

class DocScreen extends Screen {
  final SQDoc doc;

  DocScreen(
    this.doc, {
    String? title,
    super.prebody,
    super.postbody,
    super.icon,
    super.key,
  }) : super(title ?? doc.label);

  @override
  State<DocScreen> createState() => DocScreenState();
}

class DocScreenState<T extends DocScreen> extends ScreenState<T> {
  SQDoc get doc => widget.doc;
  SQCollection get collection => doc.collection;

  void loadData() async {
    await collection.ensureInitialized(doc);
    refreshScreen();
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Widget fieldDisplay(SQField<dynamic> field) {
    field.editable = false;
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
              children: collection.actions
                  .map((action) => SQButton(action.name, onPressed: () async {
                        await action.execute(doc, context);
                        refreshScreen();
                        await collection.saveDoc(doc);
                      }))
                  .toList()),
          ...doc.fields.map((field) => fieldDisplay(field.copy())).toList(),
          if (collection.readOnly == false)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (collection.updates)
                  SQButton(
                    "Edit",
                    onPressed: () async {
                      await FormScreen(doc).go(context);
                      refreshScreen();
                    },
                  ),
                if (collection.deletes)
                  SQButton("Delete", onPressed: () async {
                    await collection
                        .deleteDoc(doc)
                        .then((_) => exitScreen(context));
                  })
              ],
            ),
        ],
      ),
    );
  }
}
