import 'package:flutter/material.dart';

import '../db/fields/sq_virtual_field.dart';
import '../db/sq_collection.dart';
import '../db/fields/sq_user_ref_field.dart';
import '../ui/snackbar.dart';
import 'screen.dart';

class FormScreen extends Screen {
  late final SQDoc doc;
  final List<String>? hiddenFields;
  final String submitButtonText;
  final List<String>? shownFields;

  SQCollection get collection => doc.collection;

  FormScreen(
    this.doc, {
    String? title,
    this.hiddenFields,
    this.shownFields,
    this.submitButtonText = "Save",
    super.icon,
    super.key,
  }) : super(title ?? "Edit ${doc.collection.id}");

  @override
  State<FormScreen> createState() => FormScreenState();

  @override
  Future<T?> go<T extends Object?>(BuildContext context,
      {bool replace = false}) {
    return super.go(context, replace: false);
  }
}

class FormScreenState<T extends FormScreen> extends ScreenState<T> {
  @override
  void initState() {
    if (widget.doc.initialized == false)
      widget.collection
          .ensureInitialized(widget.doc)
          .then((_) => refreshScreen());

    for (var field in widget.doc.fields)
      if (field.runtimeType == SQEditedByField)
        field.value = SQUserRefField.currentUserRef;

    super.initState();
  }

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
  Widget? bottomNavBar() {
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
  Widget screenBody(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._generateDocFormFields(
              widget.doc,
              shownFields: widget.shownFields,
              hiddenFields: widget.hiddenFields ?? [],
              onChanged: refreshScreen,
            ),
          ],
        ),
      ),
    );
  }
}

List<SQFormField> _generateDocFormFields(
  SQDoc doc, {
  List<String> hiddenFields = const [],
  List<String>? shownFields,
  Function? onChanged,
}) {
  List<SQField<dynamic>> fields = doc.fields;

  if (shownFields != null)
    fields = fields
        .where((field) => shownFields.contains(field.name) == true)
        .toList();

  fields = fields
      .where((field) => hiddenFields.contains(field.name) == false)
      .toList();

  fields = fields.where((field) => field is! SQVirtualField).toList();

  return fields
      .map((field) => field.formField(onChanged: onChanged, doc: doc))
      .toList();
}
