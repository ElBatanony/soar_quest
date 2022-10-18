import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';

import '../firebase_options.dart';

late SQCollection items, inventory;

void main() async {
  await SQApp.init("Simple Inventory",
      firebaseOptions: DefaultFirebaseOptions.currentPlatform);

  items = FirestoreCollection(id: "Items", fields: [
    SQStringField("Name", require: true),
    SQStringField("Description"),
    SQVirtualField<int>(
        field: SQIntField("Total Stock Available"),
        valueBuilder: (doc) => inventory
            .getField<SQIntField>("Amount")!
            .sumDocs(inventory.filterBy([DocRefFilter("Item", doc.ref)]))),
    SQImageField("Image"),
    SQRefDocsField("Inventory Change Log",
        refCollection: () => inventory, refFieldName: "Item"),
  ]);

  inventory = FirestoreCollection(id: "Inventory", fields: [
    SQRefField("Item", collection: items),
    SQTimestampField("DateTime"),
    SQIntField("Amount", require: true),
  ]);

  SQApp.run(SQNavBar([
    CollectionScreen(
      collection: items,
      icon: Icons.factory,
    ),
    CollectionScreen(
      collection: inventory,
      icon: Icons.storage,
      docDisplay: (doc, s) => ListTile(
        title: Text(doc.label),
        onTap: () => s.goToDocScreen(s.docScreen(doc)),
        trailing: Text(doc.value<int>("Amount").toString()),
      ),
    ),
  ]));
}
