import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../db/conditions.dart';
import '../db/sq_action.dart';
import '../db/sq_collection.dart';
import 'doc_screen.dart';
import 'screen.dart';

DocScreen defaultDocScreen(SQDoc doc) => DocScreen(doc);

typedef DocScreenBuilder = DocScreen Function(SQDoc doc);
typedef DocDisplayBuilder = Widget Function(SQDoc doc, CollectionScreenState s);

class CollectionScreen extends Screen {
  final SQCollection collection;
  final DocScreenBuilder docScreen;
  final DocDisplayBuilder? docDisplay;
  final String? groupBy;

  CollectionScreen(
      {String? title,
      required this.collection,
      DocScreenBuilder? docScreen,
      this.docDisplay,
      super.isInline,
      super.icon,
      this.groupBy,
      super.show,
      super.key})
      : docScreen = docScreen ?? collection.docScreen,
        super(title ?? collection.id);

  @override
  State<CollectionScreen> createState() => CollectionScreenState();
}

class CollectionScreenState<T extends CollectionScreen> extends ScreenState<T> {
  SQCollection get collection => widget.collection;
  List<SQDoc> get docs => collection.docs;
  late SQAction createNewDocAction;

  @override
  void refreshScreen() {
    loadData();
    super.refreshScreen();
  }

  Future<void> loadData() async {
    await collection.loadCollection();
    super.refreshScreen();
  }

  @override
  void initState() {
    createNewDocAction = GoEditAction(
        name: "Create Doc",
        icon: Icons.add,
        onExecute: (doc) async => refreshScreen(),
        show: CollectionCond((collection) => collection.adds));
    loadData();
    super.initState();
  }

  Future<void> goToDocScreen(DocScreen docScreen) async {
    await docScreen.go(context);
    refreshScreen();
  }

  DocScreen docScreen(SQDoc doc) => widget.docScreen(doc);

  Widget docDisplay(SQDoc doc, BuildContext context) {
    if (widget.docDisplay != null) return widget.docDisplay!(doc, this);
    return ListTile(
      title: Text(doc.label),
      subtitle: doc.fields.length >= 2
          ? Text((doc.fields[1].value ?? "").toString())
          : null,
      leading: doc.imageLabel != null
          ? Image.network(doc.imageLabel!.value!, width: 35)
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: collection.actions
            .where((action) => action.show.check(doc, context))
            .map((action) => action.button(doc, isIcon: true))
            .toList(),
      ),
      onTap: () => goToDocScreen(docScreen(doc)),
    );
  }

  Widget groupByDocs(List<SQDoc> docs, BuildContext context) {
    Map<dynamic, List<SQDoc>> groups = groupBy<SQDoc, dynamic>(
        docs, (doc) => doc.value<dynamic>(widget.groupBy!));

    List<Widget> tiles = [];
    for (final entry in groups.entries) {
      tiles.add(ListTile(title: Text(entry.key.toString())));
      tiles.addAll(entry.value.map((doc) => docDisplay(doc, context)));
    }
    return ListView(shrinkWrap: true, children: tiles);
  }

  Widget docsDisplay(List<SQDoc> docs, BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: docs.map((doc) => docDisplay(doc, context)).toList(),
    );
  }

  @override
  FloatingActionButton? floatingActionButton(BuildContext context) {
    if (collection.adds)
      return createNewDocAction.fab(collection.newDoc(), context);
    return null;
  }

  @override
  Widget screenBody(BuildContext context) {
    if (widget.groupBy != null) return groupByDocs(docs, context);
    return docsDisplay(docs, context);
  }
}
