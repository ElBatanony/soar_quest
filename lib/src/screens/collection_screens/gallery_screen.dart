import 'package:flutter/material.dart';

import '../../data/sq_doc.dart';
import '../collection_screen.dart';

class GalleryScreen extends CollectionScreen {
  GalleryScreen({required super.collection, super.title});

  @override
  Widget docsDisplay(List<SQDoc> docs, ScreenState screenState) {
    return GridView.count(
      crossAxisCount: 2,
      children: docs.map((doc) => docDisplay(doc, screenState)).toList(),
    );
  }

  @override
  Widget docDisplay(SQDoc doc, ScreenState screenState) {
    return Card(
      child: InkWell(
        onTap: () => goToDocScreen(docScreen(doc), screenState),
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
}
