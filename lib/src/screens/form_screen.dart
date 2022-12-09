import 'package:flutter/material.dart';

import '../data/sq_collection.dart';
import '../ui/snackbar.dart';
import 'doc_screen.dart';

void _emptyVoid(SQDoc doc) {}

class FormScreen extends DocScreen {
  FormScreen(
    this.originalDoc, {
    String? title,
    this.submitButtonText = 'Save',
    super.icon,
    super.isInline,
    this.onFieldsChanged = _emptyVoid,
  }) : super(originalDoc.collection.newDoc(source: originalDoc.serialize()),
            title: title ?? 'Edit ${originalDoc.collection.id}');

  final String submitButtonText;
  final SQDoc originalDoc;

  final void Function(SQDoc) onFieldsChanged;

  @override
  State<FormScreen> createState() => FormScreenState();

  @override
  Future<T?> go<T extends Object?>(BuildContext context,
          {bool replace = false}) =>
      super.go(context, replace: false);

  Future<void> submitForm(ScreenState screenState) async {
    for (final field in doc.fields) {
      if (field.require && field.value == null) {
        showSnackBar('${field.name} is required!',
            context: screenState.context);
        return;
      }
    }

    originalDoc.fields = doc.copyFields();

    await collection.saveDoc(originalDoc);
    screenState.exitScreen<bool>(true);
  }

  @override
  Widget? bottomNavBar(ScreenState screenState) => BottomNavigationBar(
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
              icon: Icon(Icons.cancel), label: 'Cancel'),
          BottomNavigationBarItem(
              icon: const Icon(Icons.save), label: submitButtonText),
        ],
      );

  @override
  Widget screenBody(ScreenState screenState) => GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: super.screenBody(screenState));
}

class FormScreenState<FS extends FormScreen> extends DocScreenState<FS> {
  @override
  void refreshScreen() {
    widget.onFieldsChanged(doc);
    super.refreshScreen();
  }
}
