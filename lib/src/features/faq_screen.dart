import 'package:flutter/material.dart';

import '../screens/collection_screen.dart';

class FAQScreen extends CollectionScreen {
  FAQScreen(
      {required super.collection,
      this.answerFieldName = 'Answer',
      super.icon = Icons.question_answer});

  final Map<String, bool> expanded = {};

  final String answerFieldName;

  @override
  Widget docDisplay(doc, screenState) => ListTile(
        title: Text(doc.getValue(answerFieldName) ?? 'No answer (yet).'),
      );

  @override
  Widget collectionDisplay(docs, screenState) => SingleChildScrollView(
        child: ExpansionPanelList(
          expansionCallback: (index, isExpanded) async {
            expanded[docs[index].id] = !isExpanded;
            await refresh(refetchData: false);
          },
          children: docs
              .map(
                (doc) => ExpansionPanel(
                  canTapOnHeader: true,
                  headerBuilder: (context, isExpanded) =>
                      ListTile(title: Text(doc.label)),
                  body: docDisplay(doc, screenState),
                  isExpanded: expanded[doc.id] ?? false,
                ),
              )
              .toList(),
        ),
      );
}
