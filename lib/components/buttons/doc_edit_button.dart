import 'package:flutter/material.dart';

import '../../app/app_navigator.dart';
import '../../data.dart';

import '../../screens/doc_edit_screen.dart';

import 'sq_button.dart';

// TODO: delete button
class DocEditButton extends StatelessWidget {
  final SQDoc doc;
  final Function refresh;

  const DocEditButton(this.doc, {required this.refresh, super.key});

  void goToEditScreen(BuildContext context) async {
    await goToScreen(DocEditScreen(doc), context: context);
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return SQButton(
      "Edit ${doc.collection.singleDocName}",
      onPressed: () => goToEditScreen(context),
    );
  }
}
