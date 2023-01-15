import 'package:flutter/material.dart';

import '../../data/sq_action.dart';
import '../../data/sq_doc.dart';
import '../collection_screen.dart';

class TableScreen extends CollectionScreen {
  TableScreen({required super.collection, super.title});

  @override
  Widget docDisplay(SQDoc doc) => Row(
      children: collection.fields
          .map((field) => tableFieldCell(doc, field))
          .toList());

  Widget tableHeaderCell(SQField<dynamic> field) => Padding(
        padding: const EdgeInsets.all(3),
        child: Text(
          field.name,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      );

  TableRow tableHeaderRow() =>
      TableRow(children: collection.fields.map(tableHeaderCell).toList());

  TableRow tableDocRow(SQDoc doc) =>
      TableRow(children: (docDisplay(doc) as Row).children);

  Widget tableFieldCell(SQDoc doc, SQField<dynamic> field) => GestureDetector(
        onTap: () async => GoScreenAction('Go Doc Screen', toScreen: docScreen)
            .execute(doc, this),
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
