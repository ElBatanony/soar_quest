import 'package:flutter/material.dart';

import '../collection_screen.dart';

class GalleryScreen extends CollectionScreen {
  GalleryScreen({
    required super.collection,
    super.title,
    this.columns = 2,
  });

  final int columns;

  @override
  Widget collectionDisplay(docs) => GridView.count(
      crossAxisCount: columns, children: docs.map(docDisplay).toList());

  @override
  Widget docDisplay(doc) => Card(
        child: InkWell(
          onTap: () async => goToDocScreen(docScreen(doc)),
          child: Column(
            children: [
              if (doc.imageLabel != null)
                Image.network(doc.imageLabel!, height: 120)
              else
                const SizedBox(
                    height: 120, child: Center(child: Text('No Image'))),
              Text(doc.label)
            ],
          ),
        ),
      );
}
