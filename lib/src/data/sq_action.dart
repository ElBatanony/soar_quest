import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/doc_screen.dart';
import '../screens/form_screen.dart';
import '../screens/screen.dart';
import '../ui/sq_action_button.dart';
import '../ui/sq_button.dart';
import 'sq_collection.dart';

Future<void> emptyOnExecute(doc, context) async {}

abstract class SQAction {
  SQAction(
    this.name, {
    this.icon = Icons.double_arrow_outlined,
    this.show = trueCond,
    this.onExecute = emptyOnExecute,
    this.confirm = false,
    this.confirmMessage = 'Are you sure?',
  });

  final String name;
  final IconData icon;
  final DocCond show;
  final bool confirm;
  final String confirmMessage;
  Future<void> Function(SQDoc doc, ScreenState screenState) onExecute;

  Future<void> execute(SQDoc doc, ScreenState screenState) async {
    debugPrint('Executing action: $name');
    await onExecute(doc, screenState);
  }

  Widget button(
    SQDoc doc, {
    required ScreenState screenState,
    bool isIcon = false,
    double iconSize = 24.0,
  }) =>
      SQActionButton(
        action: this,
        doc: doc,
        screenState: screenState,
        isIcon: isIcon,
        iconSize: iconSize,
      );

  FloatingActionButton fab(SQDoc doc, ScreenState screenState) =>
      FloatingActionButton(
        heroTag: null,
        shape: const CircleBorder(),
        onPressed: () async => execute(doc, screenState),
        child: Icon(icon),
      );
}

class GoEditCloneAction extends GoScreenAction {
  GoEditCloneAction(super.name, {super.icon, super.show})
      : super(
          screen: (doc) =>
              FormScreen(doc.collection.newDoc(source: doc.serialize())),
        );
}

class GoScreenAction extends SQAction {
  GoScreenAction(
    super.name, {
    required this.screen,
    super.icon,
    super.show,
    super.onExecute,
    this.replace = false,
  });

  Screen Function(SQDoc) screen;
  bool replace;

  @override
  execute(SQDoc doc, ScreenState screenState) async {
    await screen(doc).go(screenState.context, replace: replace);
    screenState.refreshScreen();
    await super.execute(doc, screenState);
  }
}

class GoEditAction extends GoScreenAction {
  GoEditAction(
      {String name = 'Edit',
      IconData icon = Icons.edit,
      DocCond show = trueCond,
      super.onExecute})
      : super(
          name,
          icon: icon,
          show: DocCond((doc, _) => doc.collection.updates.edits) & show,
          screen: FormScreen.new,
        );
}

class CreateDocAction extends SQAction {
  CreateDocAction(
    super.name, {
    required this.getCollection,
    required this.initialFields,
    super.icon,
    super.show,
    super.onExecute,
    this.form = true,
    this.goBack = true,
  });

  SQCollection Function() getCollection;
  List<SQField<dynamic>> Function(SQDoc) initialFields;
  bool form;
  bool goBack;

  @override
  Future<void> execute(SQDoc doc, ScreenState screenState) async {
    final newDoc = getCollection().newDoc(source: source(doc));

    if (form) {
      final isCreated =
          await FormScreen(newDoc).go<bool>(screenState.context) ?? false;
      if (isCreated && !goBack && screenState.mounted)
        await DocScreen(newDoc).go(screenState.context);
    } else {
      await getCollection().saveDoc(newDoc);
      if (!goBack && screenState.mounted)
        await DocScreen(newDoc).go(screenState.context);
    }

    screenState.refreshScreen();

    return super.execute(doc, screenState);
  }
}

class DeleteDocAction extends SQAction {
  DeleteDocAction({
    String name = 'Delete',
    super.icon = Icons.delete,
    DocCond show = trueCond,
    super.onExecute,
    this.exitScreen = false,
    super.confirm = true,
  }) : super(name,
            show: CollectionCond((collection) => collection.updates.deletes) &
                show);

  bool exitScreen;

  @override
  execute(SQDoc doc, ScreenState screenState) async {
    await doc.collection.deleteDoc(doc);
    screenState.refreshScreen();
    if (exitScreen) screenState.exitScreen();
    await super.execute(doc, screenState);
  }
}

class SetFieldsAction extends SQAction {
  SetFieldsAction(super.name,
      {required this.getFields, super.icon, super.show, super.onExecute});

  Map<String, dynamic> Function(SQDoc doc) getFields;

  @override
  Future<void> execute(SQDoc doc, ScreenState screenState) async {
    final newFields = getFields(doc);
    for (final entry in newFields.entries) {
      doc.setValue(entry.key, entry.value);
    }
    await doc.collection.saveDoc(doc);
    screenState.refreshScreen();
    await super.execute(doc, screenState);
  }
}

class ExecuteOnDocsAction extends SQAction {
  ExecuteOnDocsAction(
    super.name, {
    required this.getDocs,
    required this.action,
    super.icon,
    super.show,
    super.onExecute,
  });

  List<SQDoc> Function(SQDoc) getDocs;
  SQAction action;

  @override
  Future<void> execute(SQDoc doc, ScreenState screenState) async {
    final fetchedDocs = getDocs(doc);
    for (final doc in fetchedDocs) {
      await action.execute(doc, screenState);
    }
    await super.execute(doc, screenState);
  }
}

class OpenUrlAction extends SQAction {
  OpenUrlAction(super.name, {required this.getUrl, super.icon, super.show});

  String Function(SQDoc doc) getUrl;

  @override
  Future<void> execute(SQDoc doc, ScreenState screenState) async {
    final url = getUrl(doc);
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
    await super.execute(doc, screenState);
  }
}

class SequencesAction extends SQAction {
  SequencesAction(super.name, {required this.actions, super.icon, super.show});

  List<SQAction> actions;

  @override
  Future<void> execute(SQDoc doc, ScreenState screenState) async {
    for (final action in actions) {
      await action.execute(doc, screenState);
    }
    await super.execute(doc, screenState);
  }
}

class CustomAction extends SQAction {
  CustomAction(super.name,
      {required this.customExecute, super.icon, super.show, super.onExecute});

  Future<void> Function(SQDoc doc, ScreenState screenState) customExecute;

  @override
  Future<void> execute(SQDoc doc, ScreenState screenState) async {
    await customExecute(doc, screenState);
    await super.execute(doc, screenState);
  }
}

Future<bool> showConfirmationDialog(
    {required SQAction action, required BuildContext context}) async {
  final isConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
              title: const Text('Confirm'),
              content: Text(action.confirmMessage),
              actions: [
                SQButton('Cancel',
                    onPressed: () => Navigator.pop(context, false)),
                SQButton(action.name,
                    onPressed: () => Navigator.pop(context, true)),
              ]));
  return isConfirmed ?? false;
}
