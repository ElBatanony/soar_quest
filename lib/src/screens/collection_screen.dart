import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../data/sq_action.dart';
import '../data/sq_collection.dart';
import 'doc_screen.dart';
import 'screen.dart';

class CollectionScreen extends Screen {
  CollectionScreen({
    required this.collection,
    String? title,
    super.isInline,
    super.icon,
    this.groupByField,
    super.signedIn,
    super.show,
  }) : super(title: title ?? collection.id);

  final SQCollection collection;
  final String? groupByField;

  List<SQDoc> get docs => collection.docs;

  @override
  createState() => CollectionScreenState();

  Widget groupByDocs(List<SQDoc> docs, CollectionScreenState screenState) {
    final groups = groupBy<SQDoc, dynamic>(
        docs, (doc) => doc.getValue<dynamic>(groupByField!));

    final tiles = <Widget>[];
    for (final entry in groups.entries) {
      tiles
        ..add(ListTile(title: Text(entry.key.toString())))
        ..addAll(entry.value.map((doc) => docDisplay(doc, screenState)));
    }
    return ListView(shrinkWrap: true, children: tiles);
  }

  @override
  FloatingActionButton? floatingActionButton(ScreenState screenState) {
    if (collection.updates.adds) {
      final SQAction createNewDocAction = GoEditAction(
          name: 'Create Doc',
          icon: Icons.add,
          onExecute: (doc, context) async => screenState.refreshScreen(),
          show: CollectionCond((collection) => collection.updates.adds));
      return createNewDocAction.fab(collection.newDoc(), screenState);
    }
    return null;
  }

  Widget docDisplay(SQDoc doc, CollectionScreenState screenState) => ListTile(
        title: Text(doc.label),
        subtitle: doc.secondaryLabel == null ? null : Text(doc.secondaryLabel!),
        leading: doc.imageLabel != null
            ? Image.network(doc.imageLabel!, width: 70)
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
        onTap: () async => goToDocScreen(docScreen(doc), screenState),
      );

  Widget docsDisplay(List<SQDoc> docs, CollectionScreenState screenState) =>
      ListView(
        shrinkWrap: true,
        children: docs.map((doc) => docDisplay(doc, screenState)).toList(),
      );

  Future<void> goToDocScreen(
      Screen docScreen, CollectionScreenState screenState) async {
    await docScreen.go(screenState.context);
    await screenState.refreshScreen();
  }

  Screen docScreen(SQDoc doc) => DocScreen(doc);

  @override
  Widget screenBody(screenState) {
    if (docs.isEmpty) return const Center(child: Text('This list is empty'));
    if (groupByField != null)
      return groupByDocs(docs, screenState as CollectionScreenState);
    return docsDisplay(docs, screenState as CollectionScreenState);
  }
}

class CollectionScreenState<T extends CollectionScreen> extends ScreenState<T> {
  @override
  Future<void> refreshScreen({bool refetchData = true}) async {
    if (refetchData) unawaited(loadData());
    super.refreshScreen();
  }

  Future<void> loadData() async {
    await widget.collection.loadCollection();
    super.refreshScreen();
  }

  @override
  void initState() {
    unawaited(loadData());
    super.initState();
  }
}
