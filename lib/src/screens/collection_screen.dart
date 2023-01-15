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

  Widget groupByDocs(List<SQDoc> docs) {
    final groups = groupBy<SQDoc, dynamic>(
        docs, (doc) => doc.getValue<dynamic>(groupByField!));

    final tiles = <Widget>[];
    for (final entry in groups.entries) {
      tiles
        ..add(ListTile(title: Text(entry.key.toString())))
        ..addAll(entry.value.map(docDisplay));
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

  Widget docDisplay(SQDoc doc) => ListTile(
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
              .map((action) => action.button(doc, screen: this, isIcon: true))
              .toList(),
        ),
        onTap: () async => goToDocScreen(docScreen(doc)),
      );

  Widget collectionDisplay(List<SQDoc> docs) => ListView(
        shrinkWrap: true,
        children: docs.map(docDisplay).toList(),
      );

  Future<void> goToDocScreen(Screen docScreen) async {
    await docScreen.go(context);
    await refresh();
  }

  Screen docScreen(SQDoc doc) => DocScreen(doc);

  @override
  Widget screenBody() {
    final docs = collection.docs;
    if (docs.isEmpty) return const Center(child: Text('This list is empty'));
    if (groupByField != null) return groupByDocs(docs);
    return collectionDisplay(docs);
  }

  @override
  Future<void> refresh({bool refetchData = true}) async {
    if (refetchData) unawaited(loadData());
    super.refresh();
  }

  Future<void> loadData() async {
    await collection.loadCollection();
    super.refresh();
  }

  @override
  void initScreen() {
    unawaited(loadData());
    super.initScreen();
  }
}
