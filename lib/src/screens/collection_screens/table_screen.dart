import 'package:flutter/material.dart';

import '../../data/sq_action.dart';
import '../../data/sq_doc.dart';
import '../collection_screen.dart';

class TableScreen extends CollectionScreen {
  TableScreen({required super.collection, super.title});

  @override
  Widget docDisplay(SQDoc doc, ScreenState screenState) => Row(
      children: collection.fields
          .map((field) => tableFieldCell(doc, field, screenState))
          .toList());

  Widget tableHeaderCell(SQField<dynamic> field, ScreenState screenState) =>
      Padding(
        padding: const EdgeInsets.all(3),
        child: Text(
          field.name,
          style: Theme.of(screenState.context).textTheme.titleSmall,
        ),
      );

  TableRow tableHeaderRow(ScreenState screenState) => TableRow(
      children: collection.fields
          .map((field) => tableHeaderCell(field, screenState))
          .toList());

  TableRow tableDocRow(SQDoc doc, ScreenState screenState) =>
      TableRow(children: (docDisplay(doc, screenState) as Row).children);

  Widget tableFieldCell(
          SQDoc doc, SQField<dynamic> field, ScreenState screenState) =>
      GestureDetector(
        onTap: () async => GoScreenAction('Go Doc Screen', screen: docScreen)
            .execute(doc, screenState),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Text(doc.getValue<dynamic>(field.name).toString()),
        ),
      );

  @override
  Widget screenBody() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          border: TableBorder.all(),
          defaultColumnWidth: const IntrinsicColumnWidth(),
          children: [tableHeaderRow(), ...collection.docs.map(tableDocRow)],
        ),
      );
}
