import 'package:flutter/material.dart';
import 'package:soar_quest/app.dart';
import 'package:soar_quest/db.dart';
import 'package:soar_quest/screens.dart';
import 'package:soar_quest/storage.dart';

import '../firebase_options.dart';

void main() async {
  App simpleInventoryApp = App("Simple Inventory",
      firebaseOptions: DefaultFirebaseOptions.currentPlatform);

  // TODO: add DateTime field

  await simpleInventoryApp.init();

  SQFileStorage firebaseFileStorage = FirebaseFileStorage();

  SQCollection items = FirestoreCollection(id: "Items", fields: [
    SQStringField("Name"),
    SQStringField("Description"),
    SQImageField("Image", storage: firebaseFileStorage),
    SQFileField("Test File", storage: firebaseFileStorage),
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
  ]));
}
