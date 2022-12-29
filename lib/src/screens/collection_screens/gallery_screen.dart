import 'package:flutter/material.dart';

import '../collection_screen.dart';

class GalleryScreen extends CollectionScreen {
  GalleryScreen({required super.collection, super.title});

  @override
  Widget collectionDisplay(docs) => GridView.count(
        crossAxisCount: 2,
        children: docs.map(docDisplay).toList(),
      );

  @override
  Widget docDisplay(doc, screenState) => Card(
        child: InkWell(
          onTap: () async => goToDocScreen(docScreen(doc), screenState),
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
