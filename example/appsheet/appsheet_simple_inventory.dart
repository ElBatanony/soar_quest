import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';

import '../firebase_options.dart';

late SQCollection items, inventory;

void main() async {
  App simpleInventoryApp = App("Simple Inventory",
      firebaseOptions: DefaultFirebaseOptions.currentPlatform);

  await simpleInventoryApp.init();

  items = FirestoreCollection(id: "Items", fields: [
    SQStringField("Name", isRequired: true),
    SQStringField("Description"),
    SQVirtualField<int>(
        field: SQIntField("Total Stock Available"),
        valueBuilder: (doc) {
          int sum = 0;
          for (final doc in inventory.filterBy([DocRefFilter("Item", doc.ref)]))
            sum += (doc.value("Amount") as int);
          return sum;
        }),
    SQImageField("Image"),
  ]);

  inventory = FirestoreCollection(id: "Inventory", fields: [
    SQRefField("Item", collection: items),
    SQTimestampField("DateTime"),
    SQIntField("Amount", isRequired: true),
  ]);

  items.fields.add(SQInverseRefField("Inventory Change Log",
      refFieldName: "Item", collection: inventory));

  simpleInventoryApp.run(MainScreen([
    CollectionScreen(
      collection: items,
      icon: Icons.factory,
      canCreate: true,
    ),
    CollectionScreen(
      collection: inventory,
      icon: Icons.storage,
      canCreate: true,
      docDisplay: (doc, s) => ListTile(
        title: Text(doc.label),
        onTap: () => s.goToDocScreen(s.docScreen(doc)),
        trailing: Text(doc.value("Amount").toString()),
      ),
    ),
  ]));
}
