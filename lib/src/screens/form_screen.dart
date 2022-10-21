import 'package:flutter/material.dart';

import '../db/sq_collection.dart';
import '../ui/snackbar.dart';
import 'doc_screen.dart';

class FormScreen extends DocScreen {
  final String submitButtonText;

  SQCollection get collection => doc.collection;

  FormScreen(
    SQDoc doc, {
    String? title,
    this.submitButtonText = "Save",
    super.icon,
    super.key,
  }) : super(doc, title: title ?? "Edit ${doc.collection.id}");

  @override
  State<FormScreen> createState() => FormScreenState();

  @override
  Future<T?> go<T extends Object?>(BuildContext context,
      {bool replace = false}) {
    return super.go(context, replace: false);
  }
}

class FormScreenState<T extends FormScreen> extends DocScreenState<T> {
  Future<void> submitForm() async {
    for (final field in widget.doc.fields) {
      if (field.require && field.value == null) {
        showSnackBar("${field.name} is required!", context: context);
        return;
      }
    }

    await widget.collection.saveDoc(widget.doc).then(
          (_) => exitScreen<bool>(true),
        );
  }

  @override
  Widget? bottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.grey[100],
      currentIndex: 1,
      onTap: (index) async {
        if (index == 0) {
          FocusManager.instance.primaryFocus?.unfocus();
          return exitScreen();
        }
        await submitForm();
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.cancel), label: "Cancel"),
        BottomNavigationBarItem(
            icon: Icon(Icons.save), label: widget.submitButtonText),
      ],
    );
  }

  @override
  Widget fieldDisplay(SQField<dynamic> field, BuildContext context) {
    return field.formField(onChanged: refreshScreen, doc: doc);
  }

  @override
  Widget actionsDisplay(BuildContext context) => Container();

  @override
  Widget screenBody(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: super.screenBody(context));
  }
}
