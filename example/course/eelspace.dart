import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';

import '../firebase_options.dart';

bool isAdmin = true;

late SQCollection talents, services;

void main() async {
  await SQApp.init("eelspace",
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      firebaseOptions: DefaultFirebaseOptions.currentPlatform);

  talents = FirestoreCollection(id: "Talents", fields: [
    SQStringField("Name"),
    SQImageField("Image"),
    SQStringField("Skill"),
    SQStringField("Country"),
    SQStringField("Contact Details"),
    SQRefDocsField("Services",
        refCollection: () => services, refFieldName: "Talent"),
  ], actions: [
    GoScreenAction("View Service",
        screen: (talentDoc) => CollectionScreen(
            collection: CollectionSlice(services,
                filter: RefFilter("Talent", talentDoc.ref))))
  ]);

  services = FirestoreCollection(id: "Services", fields: [
    SQStringField("Name"),
    SQRefField("Talent", collection: talents),
    SQImageField("Image"),
    SQStringField("Description"),
    SQStringField("Duration"),
    SQStringField("Price"),
  ], actions: [
    CustomAction("Order Now", customExecute: (doc, context) async {
      showSnackBar("Should order service", context: context);
    })
  ]);

  SQApp.run(
    [
      Screen("Home", icon: Icons.home),
      CollectionScreen(collection: talents, icon: Icons.group),
      Screen("Chats",
          icon: Icons.chat), // Use Telegram or LinkedIn instead? 😉😉
      CollectionScreen(collection: services, icon: Icons.room_service),
    ],
    drawer: SQDrawer([]),
    startingScreen: 1,
  );
}
