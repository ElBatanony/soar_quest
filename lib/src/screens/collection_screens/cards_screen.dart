import 'package:flutter/material.dart';

import '../../db/sq_doc.dart';
import '../collection_screen.dart';

class CardsScreen extends CollectionScreen {
  CardsScreen({required super.collection, super.title});

  @override
  createState() => _CardsScreenState();
}

class _CardsScreenState extends CollectionScreenState<CardsScreen> {
  @override
  Widget docDisplay(SQDoc doc, BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => goToDocScreen(docScreen(doc)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.label,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      doc.fields.length >= 2
                          ? Text((doc.fields[1].value ?? "").toString())
                          : Container()
                    ],
                  ),
                ],
              ),
              doc.imageLabel != null
                  ? Image.network(doc.imageLabel!.value!, height: 120)
                  : Container(),
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: collection.actions
                      .where((action) => action.show.check(doc, context))
                      .take(3)
                      .map((action) => action.button(doc, isIcon: true))
                      .toList()),
            ],
          ),
        ),
      ),
    );
  }
}