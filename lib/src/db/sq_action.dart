import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/doc_screen.dart';
import '../screens/form_screen.dart';
import '../ui/sq_button.dart';
import '../screens/screen.dart';
import 'fields/sq_list_field.dart';
import 'sq_collection.dart';

Future<void> emptyOnExecute(doc, context) async {}

abstract class SQAction {
  final String name;
  final IconData icon;
  final DocCond show;
  final bool confirm;
  final String confirmMessage;
  Future<void> Function(SQDoc, BuildContext) onExecute;

  SQAction(this.name,
      {this.icon = Icons.double_arrow_outlined,
      this.show = trueCond,
      this.onExecute = emptyOnExecute,
      this.confirm = false,
      this.confirmMessage = "Are you sure?"});

  Future<void> execute(SQDoc doc, BuildContext context) async {
    print("Executing action: $name");
    await onExecute(doc, context);
  }

  Widget button(SQDoc doc, {bool isIcon = false, double iconSize = 24.0}) {
    return SQActionButton(
        action: this, doc: doc, isIcon: isIcon, iconSize: iconSize);
  }

  FloatingActionButton fab(SQDoc doc, BuildContext context) {
    return FloatingActionButton(
        heroTag: null,
        shape: CircleBorder(),
        onPressed: () => execute(doc, context),
        child: Icon(icon));
  }
}

class SQActionButton extends StatefulWidget {
  final SQAction action;
  final bool isIcon;
  final SQDoc doc;
  final double iconSize;

  const SQActionButton(
      {required this.action,
      required this.doc,
      this.isIcon = false,
      this.iconSize = 24.0});

  @override
  State<SQActionButton> createState() => _SQActionButtonState();
}

class _SQActionButtonState extends State<SQActionButton> {
  late bool inForm;

  @override
  void initState() {
    inForm = ScreenState.of(context) is FormScreenState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (inForm) return Container();

    return SQButton.icon(
      widget.action.icon,
      iconSize: widget.iconSize,
      text: widget.isIcon
          ? null
          : widget.action.name.isEmpty
              ? null
              : widget.action.name,
      onPressed: () async {
        bool confirmed = widget.action.confirm == false ||
            await showConfirmationDialog(
                action: widget.action, context: context);
        if (confirmed) return widget.action.execute(widget.doc, context);
      },
    );
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
  bool replace;

  GoScreenAction(
    super.name, {
    super.icon,
    super.show,
    super.onExecute,
    required this.screen,
    this.replace = false,
  });

  @override
  execute(SQDoc doc, BuildContext context) async {
    await screen(doc).go(context, replace: replace);
    ScreenState.of(context).refreshScreen();
    await super.execute(doc, context);
  }
}

class GoEditAction extends GoScreenAction {
  GoEditAction(
      {String name = "Edit",
      IconData icon = Icons.edit,
      DocCond show = trueCond,
      super.onExecute})
      : super(
          name,
          icon: icon,
          show: DocCond((doc, _) => doc.collection.updates) & show,
          screen: (doc) => FormScreen(doc),
        );
}

class CreateDocAction extends SQAction {
  SQCollection Function() getCollection;
  List<SQField<dynamic>> Function(SQDoc) initialFields;
  bool form;
  bool goBack;

  CreateDocAction(
    super.name, {
    super.icon,
    super.show,
    super.onExecute,
    required this.getCollection,
    required this.initialFields,
    this.form = true,
    this.goBack = true,
  });

  @override
  Future<void> execute(SQDoc doc, BuildContext context) async {
    final newDoc = getCollection().newDoc(initialFields: initialFields(doc));

    if (form) {
      bool created = await FormScreen(newDoc).go<bool>(context) ?? false;
      if (created && !goBack) await DocScreen(newDoc).go(context);
    } else {
      getCollection().saveDoc(newDoc);
      if (!goBack) DocScreen(newDoc).go(context);
    }

    ScreenState.of(context).refreshScreen();

    return super.execute(doc, context);
  }
}

class DeleteDocAction extends SQAction {
  bool exitScreen;

  DeleteDocAction({
    String name = "Delete",
    super.icon = Icons.delete,
    DocCond show = trueCond,
    super.onExecute,
    this.exitScreen = false,
    super.confirm = true,
  }) : super(name,
            show: CollectionCond((collection) => collection.deletes) & show);

  @override
  execute(SQDoc doc, BuildContext context) async {
    await doc.collection.deleteDoc(doc);
    if (exitScreen) ScreenState.of(context).exitScreen();
    await super.execute(doc, context);
  }
}

class SetFieldsAction extends SQAction {
  Map<String, dynamic> Function(SQDoc doc) getFields;

  SetFieldsAction(super.name,
      {super.icon, super.show, super.onExecute, required this.getFields});

  @override
  Future<void> execute(SQDoc doc, BuildContext context) async {
    Map<String, dynamic> newFields = getFields(doc);
    for (final entry in newFields.entries) {
      SQField<dynamic>? docField = doc.getField(entry.key);
      if (docField == null) throw "SetFieldsAction null doc field";
      docField.value = entry.value;
    }
    await doc.collection.saveDoc(doc);
    ScreenState.of(context).refreshScreen();
    await super.execute(doc, context);
  }
}

class ExecuteOnDocsAction extends SQAction {
  List<SQDoc> Function(SQDoc) getDocs;
  SQAction action;

  ExecuteOnDocsAction(
    super.name, {
    super.icon,
    super.show,
    super.onExecute,
    required this.getDocs,
    required this.action,
  });

  @override
  Future<void> execute(SQDoc doc, BuildContext context) async {
    List<SQDoc> fetchedDocs = getDocs(doc);
    for (final doc in fetchedDocs) {
      await action.execute(doc, context);
    }
    await super.execute(doc, context);
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
    await super.execute(doc, context);
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
    await super.execute(doc, context);
  }
}

class CustomAction extends SQAction {
  Future<void> Function(SQDoc doc, BuildContext context) customExecute;

  CustomAction(super.name,
      {super.icon, super.show, required this.customExecute, super.onExecute});

  @override
  Future<void> execute(SQDoc doc, BuildContext context) async {
    await customExecute(doc, context);
    await super.execute(doc, context);
  }
}

Future<bool> showConfirmationDialog(
    {required SQAction action, required BuildContext context}) async {
  bool? ret = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Confirm"),
            content: Text(action.confirmMessage),
            actions: [
              SQButton('Cancel',
                  onPressed: () => Navigator.pop(context, false)),
              SQButton(action.name,
                  onPressed: () => Navigator.pop(context, true)),
            ]);
      });
  return ret ?? false;
}
