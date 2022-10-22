import 'package:flutter/material.dart';

import '../../db/sq_action.dart';
import '../../db/sq_doc.dart';
import '../collection_screen.dart';

class TableScreen extends CollectionScreen {
  TableScreen({required super.collection, super.title});

  @override
  createState() => TableScreenState();
}

class TableScreenState extends CollectionScreenState<TableScreen> {
  Widget tableHeaderCell(SQField<dynamic> field) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Text(
        field.name,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }

  TableRow tableHeaderRow() {
    return TableRow(children: collection.fields.map(tableHeaderCell).toList());
  }

  Widget tableFieldCell(SQDoc doc, SQField<dynamic> field) {
    return GestureDetector(
      onTap: () =>
          GoScreenAction("Go Doc Screen", screen: (doc) => docScreen(doc))
              .execute(doc, context),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(doc.value<dynamic>(field.name).toString()),
      ),
    );
  }

  TableRow tableDocRow(SQDoc doc) {
    return TableRow(
        children: collection.fields
            .map((field) => tableFieldCell(doc, field))
            .toList());
  }

  @override
  Widget screenBody(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(),
        defaultColumnWidth: IntrinsicColumnWidth(),
        children: [
          tableHeaderRow(),
          ...collection.docs.map(tableDocRow).toList()
        ],
      ),
    );
  }
}
