import 'package:flutter/material.dart';

import '../data/sq_collection.dart';
import '../ui/snackbar.dart';
import 'doc_screen.dart';

void _emptyVoid(SQDoc doc) {}

class FormScreen extends DocScreen {
  final String submitButtonText;
  final SQDoc originalDoc;

  final void Function(SQDoc) onFieldsChanged;

  FormScreen(
    this.originalDoc, {
    String? title,
    this.submitButtonText = "Save",
    super.icon,
    super.isInline,
    this.onFieldsChanged = _emptyVoid,
  }) : super(
            originalDoc.collection
                .newDoc(initialFields: originalDoc.copyFields()),
            title: title ?? "Edit ${originalDoc.collection.id}");

  @override
  State<FormScreen> createState() => FormScreenState();

  @override
  Future<T?> go<T extends Object?>(BuildContext context,
      {bool replace = false}) {
    return super.go(context, replace: false);
  }

  Future<void> submitForm(ScreenState screenState) async {
    for (final field in doc.fields) {
      if (field.require && field.value == null) {
        showSnackBar("${field.name} is required!",
            context: screenState.context);
        return;
      }
    }

    originalDoc.fields = doc.copyFields();

    await collection.saveDoc(originalDoc);
    screenState.exitScreen<bool>(true);
  }

  @override
  Widget? bottomNavBar(ScreenState screenState) {
    return BottomNavigationBar(
      backgroundColor: Colors.grey[100],
      currentIndex: 1,
      onTap: (index) async {
        if (index == 0) {
          FocusManager.instance.primaryFocus?.unfocus();
          return screenState.exitScreen();
        }
        await submitForm(screenState);
      },
      items: [
        const BottomNavigationBarItem(
            icon: Icon(Icons.cancel), label: "Cancel"),
        BottomNavigationBarItem(
            icon: const Icon(Icons.save), label: submitButtonText),
      ],
    );
  }

  @override
  Widget screenBody(ScreenState screenState) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: super.screenBody(screenState));
  }
}

class FormScreenState<T extends FormScreen> extends ScreenState<T> {
  @override
  void refreshScreen() {
    widget.onFieldsChanged(widget.doc);
    super.refreshScreen();
  }
}
