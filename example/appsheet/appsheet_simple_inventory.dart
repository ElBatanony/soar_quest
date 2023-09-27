import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';

late SQCollection items, inventory;

void main() async {
  await SQApp.init('Simple Inventory');

  items = LocalCollection(id: 'Items', fields: [
    SQStringField('Name')..require = false,
    SQStringField('Description'),
    SQVirtualField<int>(
        SQIntField('Total Stock Available'),
        (doc) => inventory
            .getField<SQIntField>('Amount')!
            .sumDocs(RefFilter('Item', doc.ref).filter(inventory.docs))),
    SQInverseRefsField('Inventory Change Log',
        refCollection: () => inventory, refFieldName: 'Item'),
  ]);

  inventory = LocalCollection(id: 'Inventory', fields: [
    SQRefField('Item', collection: items),
    SQTimestampField('DateTime'),
    SQIntField('Amount')..require = true,
  ]);

  SQApp.run([
    CollectionScreen(
      collection: items,
      icon: Icons.factory,
    ),
    CollectionScreen(
      collection: inventory,
      icon: Icons.storage,
    ),
  ]);
}
