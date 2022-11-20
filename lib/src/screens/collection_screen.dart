import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../db/sq_action.dart';
import '../db/sq_collection.dart';
import 'doc_screen.dart';
import 'screen.dart';

class CollectionScreen extends Screen {
  final SQCollection collection;
  final String? groupByField;

  List<SQDoc> get docs => collection.docs;

  CollectionScreen(
      {String? title,
      required this.collection,
      super.isInline,
      super.icon,
      this.groupByField,
      super.show,
      super.key})
      : super(title: title ?? collection.id);

  @override
  State<CollectionScreen> createState() => CollectionScreenState();

  Widget groupByDocs(List<SQDoc> docs, ScreenState screenState) {
    Map<dynamic, List<SQDoc>> groups = groupBy<SQDoc, dynamic>(
        docs, (doc) => doc.value<dynamic>(groupByField!));

    List<Widget> tiles = [];
    for (final entry in groups.entries) {
      tiles.add(ListTile(title: Text(entry.key.toString())));
      tiles.addAll(entry.value.map((doc) => docDisplay(doc, screenState)));
    }
    return ListView(shrinkWrap: true, children: tiles);
  }

  @override
  FloatingActionButton? floatingActionButton(ScreenState screenState) {
    if (collection.updates.adds) {
      final SQAction createNewDocAction = GoEditAction(
          name: "Create Doc",
          icon: Icons.add,
          onExecute: (doc, context) async => screenState.refreshScreen(),
          show: CollectionCond((collection) => collection.updates.adds));
      return createNewDocAction.fab(collection.newDoc(), screenState);
    }
    return null;
  }

  Widget docDisplay(SQDoc doc, ScreenState screenState) {
    return ListTile(
      title: Text(doc.label),
      subtitle: doc.fields.length >= 2
          ? Text((doc.fields[1].value ?? "").toString())
          : null,
      leading: doc.imageLabel != null
          ? Image.network(doc.imageLabel!.value!, width: 70)
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: collection.actions
            .where((action) => action.show.check(doc, screenState))
            .take(2)
            .map((action) =>
                action.button(doc, screenState: screenState, isIcon: true))
            .toList(),
      ),
      onTap: () => goToDocScreen(docScreen(doc), screenState),
    );
  }

  Widget docsDisplay(List<SQDoc> docs, ScreenState screenState) {
    return ListView(
      shrinkWrap: true,
      children: docs.map((doc) => docDisplay(doc, screenState)).toList(),
    );
  }

  Future<void> goToDocScreen(Screen docScreen, ScreenState screenState) async {
    await docScreen.go(screenState.context);
    screenState.refreshScreen();
  }

  Screen docScreen(SQDoc doc) => DocScreen(doc);

  @override
  Widget screenBody(ScreenState screenState) {
    if (docs.isEmpty) return Center(child: Text("This list is empty"));
    if (groupByField != null) return groupByDocs(docs, screenState);
    return docsDisplay(docs, screenState);
  }
}

class CollectionScreenState<T extends CollectionScreen> extends ScreenState<T> {
  @override
  void refreshScreen() {
    loadData();
    super.refreshScreen();
  }

  Future<void> loadData() async {
    await widget.collection.loadCollection();
    super.refreshScreen();
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }
}
