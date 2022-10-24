import 'package:flutter/material.dart';

import '../../db/sq_doc.dart';
import '../collection_screen.dart';

class GalleryScreen extends CollectionScreen {
  GalleryScreen({required super.collection, super.title});

  @override
  createState() => GalleryScreenState();
}

class GalleryScreenState extends CollectionScreenState<GalleryScreen> {
  @override
  Widget docDisplay(SQDoc doc, BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => goToDocScreen(docScreen(doc)),
        child: Column(
          children: [
            doc.imageLabel != null
                ? Image.network(doc.imageLabel!.value!, height: 120)
                : SizedBox(height: 120, child: Center(child: Text("No Image"))),
            Text(doc.label)
          ],
        ),
      ),
    );
  }

  @override
  Widget docsDisplay(List<SQDoc> docs, BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: docs.map((doc) => docDisplay(doc, context)).toList(),
    );
  }
}
