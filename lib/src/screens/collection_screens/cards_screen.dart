import 'package:flutter/material.dart';

import '../collection_screen.dart';

class CardsScreen extends CollectionScreen {
  CardsScreen({required super.collection, super.title});

  @override
  Widget docDisplay(doc, screenState) => Card(
        child: InkWell(
          onTap: () async => goToDocScreen(docScreen(doc), screenState),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc.label,
                          style:
                              Theme.of(screenState.context).textTheme.headline6,
                        ),
                        if (doc.secondaryLabel != null)
                          Text(doc.secondaryLabel!)
                      ],
                    ),
                  ],
                ),
                if (doc.imageLabel != null)
                  Image.network(doc.imageLabel!, height: 120),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: collection.actions
                        .where((action) => action.show.check(doc, screenState))
                        .take(3)
                        .map((action) => action.button(doc,
                            screenState: screenState, isIcon: true))
                        .toList()),
              ],
            ),
          ),
        ),
      );
}
