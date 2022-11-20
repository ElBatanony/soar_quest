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
            .sumDocs(inventory.filterBy([RefFilter("Item", doc.ref)]))),
    SQImageField("Image"),
    SQInverseRefsField("Inventory Change Log",
        refCollection: () => inventory, refFieldName: "Item"),
  ]);

  inventory = FirestoreCollection(id: "Inventory", fields: [
    SQRefField("Item", collection: items),
    SQTimestampField("DateTime"),
    SQIntField("Amount", require: true),
  ]);

  SQApp.run([
    CollectionScreen(
      collection: items,
      icon: Icons.factory,
    ),
    CollectionScreen(
      collection: inventory,
      icon: Icons.storage,
      customDocDisplay: (doc, screenState) => ListTile(
        title: Text(doc.label),
        onTap: () => DocScreen(doc).go(screenState.context),
        trailing: Text(doc.value<int>("Amount").toString()),
      ),
    ),
  ]);
}
