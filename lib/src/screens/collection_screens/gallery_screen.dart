import 'package:flutter/material.dart';

import '../collection_screen.dart';

class GalleryScreen extends CollectionScreen {
  GalleryScreen({
    required super.collection,
    super.title,
    this.columns = 2,
    this.childAspectRatio = 1.0,
    super.icon,
  });

  int columns;
  double childAspectRatio;

  @override
  Widget collectionDisplay(docs) => GridView.builder(
        itemCount: docs.length,
        itemBuilder: (context, index) => docDisplay(docs[index]),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns, childAspectRatio: childAspectRatio),
      );

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
