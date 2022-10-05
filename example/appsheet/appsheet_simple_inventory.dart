import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';

import '../firebase_options.dart';

void main() async {
  App simpleInventoryApp = App("Simple Inventory",
      firebaseOptions: DefaultFirebaseOptions.currentPlatform);

  // TODO: add DateTime field

  await simpleInventoryApp.init();

  AppSettings.setSettings([
    SQBoolField("isOn"),
    SQBoolField("hamada"),
  ]);

  SQCollection items = FirestoreCollection(id: "Items", fields: [
    SQStringField("Name", isRequired: true),
    SQStringField("Description"),
    SQImageField("Image"),
    // TODO: add inventory change log
    // TODO: add Total Stock Available
  ]);

  SQCollection inventory = FirestoreCollection(id: "Inventory", fields: [
    SQRefField("Item", collection: items),
    SQTimestampField("DateTime"),
    SQIntField("Amount")
  ]);

  simpleInventoryApp.run(MainScreen([
    CollectionScreen(
      collection: items,
      icon: Icons.factory,
      canCreate: true,
    ),
    CollectionScreen(collection: inventory),
    AppSettings.settingsScreen(),
  ]));
}
