import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/form_screen.dart';
import '../screens/form_screens/doc_create_screen.dart';
import '../screens/screen.dart';
import 'fields/sq_list_field.dart';
import 'sq_collection.dart';

abstract class SQAction {
  final String name;

  SQAction(this.name);

  Future execute(SQDoc doc, BuildContext context);
}

class CloneEditAction extends SQAction {
  CloneEditAction(super.name);

  @override
  Future execute(SQDoc doc, BuildContext context) async {
    return docCreateScreen(doc.collection, initialFields: copyList(doc.fields))
        .go(context);
  }
}

class GoScreenAction extends SQAction {
  Screen Function(SQDoc) screen;

  GoScreenAction(super.name, {required this.screen});

  @override
  Future execute(SQDoc doc, BuildContext context) async {
    return screen(doc).go(context);
  }
}

// TODO: replace in DocScreen
class GoEditDocAction extends SQAction {
  GoEditDocAction(super.name);

  @override
  Future execute(SQDoc doc, BuildContext context) {
    // TODO: use GoScreen as parent class
    return FormScreen(doc).go(context);
  }
}

class NewDocFromDataAction extends SQAction {
  SQCollection Function() getCollection;
  List<SQField> Function(SQDoc) initialFields;

  NewDocFromDataAction(super.name,
      {required this.getCollection, required this.initialFields});

  @override
  Future execute(SQDoc doc, BuildContext context) {
    // TODO: maybe inherit from GoScreenAction
    return docCreateScreen(getCollection(), initialFields: initialFields(doc))
        .go(context);
  }
}

// TODO: replace in DocScreen
class DeleteDocAction extends SQAction {
  DeleteDocAction(super.name);

  @override
  Future execute(SQDoc doc, BuildContext context) async {
    return doc.collection.deleteDoc(doc).then((_) => exitScreen(context));
  }
}

class SetFieldsAction extends SQAction {
  List<SQField> Function(SQDoc) getFields;

  SetFieldsAction(super.name, {required this.getFields});

  @override
  Future execute(SQDoc doc, BuildContext context) async {
    List<SQField> newFields = getFields(doc);
    for (final field in newFields) {
      doc.getField(field.name).value = field.value;
    }
  }
}

class ExecuteOnDocsAction extends SQAction {
  List<SQDoc> Function(SQDoc) getDocs;
  SQAction action;

  ExecuteOnDocsAction(super.name,
      {required this.getDocs, required this.action});

  @override
  Future execute(SQDoc doc, BuildContext context) async {
    List<SQDoc> fetchedDocs = getDocs(doc);
    for (final doc in fetchedDocs) {
      await action.execute(doc, context);
    }
  }
}

class OpenUrlAction extends SQAction {
  String Function(SQDoc) getUrl;

  OpenUrlAction(super.name, {required this.getUrl});

  @override
  Future execute(SQDoc doc, BuildContext context) async {
    String url = getUrl(doc);
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}

class SequencesAction extends SQAction {
  List<SQAction> actions;

  SequencesAction(super.name, {required this.actions});

  @override
  Future execute(SQDoc doc, BuildContext context) async {
    for (final action in actions) {
      await action.execute(doc, context);
    }
  }
}

class CustomAction extends SQAction {
  Future<void> Function(SQDoc, BuildContext) customExecute;

  CustomAction(super.name, {required this.customExecute});

  @override
  Future execute(SQDoc doc, BuildContext context) {
    return customExecute(doc, context);
  }
}
