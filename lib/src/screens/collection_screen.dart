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
    super.icon,
    this.groupByField,
  }) : super(title ?? collection.id);

  final SQCollection collection;
  final String? groupByField;

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
  FloatingActionButton? floatingActionButton() {
    if (collection.updates.adds) {
      final SQAction createNewDocAction = GoEditAction(
          name: 'Create Doc',
          icon: Icons.add,
          onExecute: (doc, context) async => refresh(),
          show: CollectionCond((collection) => collection.updates.adds));
      return createNewDocAction.fab(collection.newDoc(), this);
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
              .where((action) => action.show.check(doc, this))
              .take(2)
              .map((action) =>
                  action.button(doc, screenState: screenState, isIcon: true))
              .toList(),
        ),
        onTap: () async => goToDocScreen(docScreen(doc), screenState),
      );

  Widget collectionDisplay(
          List<SQDoc> docs, CollectionScreenState screenState) =>
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
  Widget screenBody() {
    final docs = collection.docs;
    if (docs.isEmpty) return const Center(child: Text('This list is empty'));
    if (groupByField != null) return groupByDocs(docs);
    return collectionDisplay(docs);
  }

class CollectionScreenState<T extends CollectionScreen> extends ScreenState<T> {
  @override
  Future<void> refresh({bool refetchData = true}) async {
    if (refetchData) unawaited(loadData());
    super.refresh();
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
