import 'package:flutter/material.dart';

import '../../data/sq_action.dart';
import '../../data/sq_doc.dart';
import '../collection_screen.dart';

class TableScreen extends CollectionScreen {
  TableScreen({required super.collection, super.title, super.isInline});

  @override
  Widget docDisplay(SQDoc doc, ScreenState screenState) {
    return Row(
        children: collection.fields
            .map((field) => tableFieldCell(doc, field, screenState))
            .toList());
  }

  Widget tableHeaderCell(SQField<dynamic> field, ScreenState screenState) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Text(
        field.name,
        style: Theme.of(screenState.context).textTheme.titleSmall,
      ),
    );
  }

  TableRow tableHeaderRow(ScreenState screenState) {
    return TableRow(
        children: collection.fields
            .map((field) => tableHeaderCell(field, screenState))
            .toList());
  }

  TableRow tableDocRow(SQDoc doc, ScreenState screenState) {
    return TableRow(children: (docDisplay(doc, screenState) as Row).children);
  }

  Widget tableFieldCell(
      SQDoc doc, SQField<dynamic> field, ScreenState screenState) {
    return GestureDetector(
      onTap: () async => GoScreenAction("Go Doc Screen", screen: docScreen)
          .execute(doc, screenState),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Text(doc.value<dynamic>(field.name).toString()),
      ),
    );
  }

  @override
  Widget screenBody(ScreenState screenState) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(),
        defaultColumnWidth: IntrinsicColumnWidth(),
        children: [
          tableHeaderRow(screenState),
          ...docs.map((doc) => tableDocRow(doc, screenState))
        ],
      ),
    );
  }
}
