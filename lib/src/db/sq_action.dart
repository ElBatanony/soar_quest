import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/form_screen.dart';
import '../ui/sq_button.dart';
import '../screens/screen.dart';
import 'fields/sq_list_field.dart';
import 'sq_collection.dart';

typedef DocCondition = bool Function(SQDoc doc);

bool alwaysShow(SQDoc doc) => true;

abstract class SQAction {
  final String name;
  final IconData icon;
  final DocCondition show;
  final bool confirm;
  final String confirmMessage;

  SQAction(this.name,
      {this.icon = Icons.double_arrow_outlined,
      this.show = alwaysShow,
      this.confirm = false,
      this.confirmMessage = "Are you sure?"});

  Future<void> execute(SQDoc doc, BuildContext context);

  Widget button(SQDoc doc, {bool isIcon = false}) {
    if (show(doc))
      return Builder(
        builder: (context) => SQButton.icon(
          icon,
          text: isIcon ? null : name,
          onPressed: () async {
            ScreenState screenState = ScreenState.of(context);
            await execute(doc, context);
            screenState.refreshScreen();
            await doc.collection.saveDoc(doc);
            screenState.refreshScreen();
          },
        ),
      );
    return Container();
  }
}

class GoEditCloneAction extends GoScreenAction {
  GoEditCloneAction(super.name, {super.icon, super.show})
      : super(
          screen: (doc) => FormScreen(
              doc.collection.newDoc(initialFields: copyList(doc.fields))),
        );
}

class GoScreenAction extends SQAction {
  Screen Function(SQDoc) screen;

  GoScreenAction(super.name, {super.icon, super.show, required this.screen});

  @override
  execute(SQDoc doc, BuildContext context) => screen(doc).go(context);
}

class GoEditAction extends GoScreenAction {
  GoEditAction({
    String name = "Edit",
    IconData icon = Icons.edit,
    DocCondition show = alwaysShow,
  }) : super(
          name,
          icon: icon,
          show: (doc) => doc.collection.updates && show(doc),
          screen: (doc) => FormScreen(doc),
        );
}

class GoDerivedDocAction extends GoScreenAction {
  SQCollection Function() getCollection;
  List<SQField<dynamic>> Function(SQDoc) initialFields;

  GoDerivedDocAction(
    super.name, {
    super.icon,
    super.show,
    required this.getCollection,
    required this.initialFields,
  }) : super(
          screen: (doc) => FormScreen(
            getCollection().newDoc(initialFields: initialFields(doc)),
          ),
        );
}

class DeleteDocAction extends SQAction {
  bool exitScreen;

  DeleteDocAction({
    String name = "Delete",
    super.icon = Icons.delete,
    DocCondition show = alwaysShow,
    this.exitScreen = false,
    super.confirm = true,
  }) : super(name, show: (doc) => doc.collection.deletes && show(doc));

  @override
  execute(SQDoc doc, BuildContext context) {
    return doc.collection.deleteDoc(doc).then((_) {
      if (exitScreen) ScreenState.of(context).exitScreen();
    });
  }
}

class SetFieldsAction extends SQAction {
  Map<String, dynamic> Function(SQDoc) getFields;

  SetFieldsAction(super.name,
      {super.icon, super.show, required this.getFields});

  @override
  Future<void> execute(SQDoc doc, BuildContext context) async {
    Map<String, dynamic> newFields = getFields(doc);
    for (final entry in newFields.entries) {
      SQField<dynamic>? docField = doc.getField(entry.key);
      if (docField == null) throw "SetFieldsAction null doc field";
      docField.value = entry.value;
    }
  }
}

class ExecuteOnDocsAction extends SQAction {
  List<SQDoc> Function(SQDoc) getDocs;
  SQAction action;

  ExecuteOnDocsAction(super.name,
      {super.icon, super.show, required this.getDocs, required this.action});

  @override
  Future<void> execute(SQDoc doc, BuildContext context) async {
    List<SQDoc> fetchedDocs = getDocs(doc);
    for (final doc in fetchedDocs) {
      await action.execute(doc, context);
    }
  }
}

class OpenUrlAction extends SQAction {
  String Function(SQDoc) getUrl;

  OpenUrlAction(super.name, {super.icon, super.show, required this.getUrl});

  @override
  Future<void> execute(SQDoc doc, BuildContext context) async {
    String url = getUrl(doc);
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}

class SequencesAction extends SQAction {
  List<SQAction> actions;

  SequencesAction(super.name, {super.icon, super.show, required this.actions});

  @override
  Future<void> execute(SQDoc doc, BuildContext context) async {
    for (final action in actions) {
      await action.execute(doc, context);
    }
  }
}

class CustomAction extends SQAction {
  Future<void> Function(SQDoc, BuildContext) customExecute;

  CustomAction(super.name,
      {super.icon, super.show, required this.customExecute});

  @override
  Future<void> execute(SQDoc doc, BuildContext context) {
    return customExecute(doc, context);
  }
}
