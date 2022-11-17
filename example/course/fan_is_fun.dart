import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';

import '../firebase_options.dart';

bool isAdmin = true;

late SQCollection feedPosts, events, bookings, teams, sports;

void main() async {
  await SQApp.init("Fan Is Fun",
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      userDocFields: [SQStringField("Telegram Handle")],
      firebaseOptions: DefaultFirebaseOptions.currentPlatform);

  sports = FirestoreCollection(id: "Sports", fields: [
    SQStringField("Sport Name"),
  ]);

  teams = FirestoreCollection(id: "Teams", fields: [
    SQStringField("Team Name"),
    SQRefField("Sport", collection: sports),
  ]);

  events = FirestoreCollection(id: "Events", fields: [
    SQStringField("Event Title"),
    SQRefField("Team", collection: teams),
    SQStringField("Location"),
    SQIntField("Capacity", value: 10),
    SQVirtualField(
        field: SQIntField("Booked Count"),
        valueBuilder: (doc) => bookings.docs
            .where((booking) => booking.value<SQRef>("Event") == doc.ref)
            .length),
    SQInverseRefsField("Bookings",
        refCollection: () => bookings, refFieldName: "Event"),
  ], actions: [
    CustomAction(
      "Book Event",
      show: isSignedIn &
          DocCond((eventDoc, context) => !bookings.docs.any((booking) =>
              booking.value<SQRef>("User") == SQAuth.userDoc!.ref &&
              booking.value<SQRef>("Event") == eventDoc.ref)) &
          DocCond((eventDoc, context) =>
              bookings.docs
                  .where((booking) =>
                      booking.value<SQRef>("Event") == eventDoc.ref)
                  .length <
              eventDoc.value<int>("Capacity")!),
      customExecute: (eventDoc, context) async {
        final newBooking = bookings.newDoc(initialFields: [
          SQUserRefField("User", value: SQAuth.userDoc!.ref),
          SQRefField("Event", collection: events, value: eventDoc.ref),
        ]);
        await bookings.saveDoc(newBooking);
      },
    )
  ]);

  bookings = FirestoreCollection(id: "Bookings", fields: [
    SQRefField("Event", collection: events),
    SQUserRefField("User"),
  ]);

  feedPosts = FirestoreCollection(
    id: "Feed",
    fields: [
      SQStringField("Post Title"),
      SQStringField("Description"),
      SQImageField("Picture"),
      SQRefField("Event", collection: events),
    ],
    actions: [
      GoScreenAction("Go To Event",
          show: DocCond((doc, context) => doc.value<SQRef>("Event") != null),
          screen: (postDoc) {
        final eventRef = postDoc.value<SQRef>("Event")!;
        return DocScreen(events.getDoc(eventRef.docId)!);
      })
    ],
    updates: isAdmin ? SQUpdates() : SQUpdates.readOnly(),
  );

  await events.loadCollection();

  SQApp.run(
    [
      CollectionScreen(collection: feedPosts),
      CollectionScreen(collection: events),
    ],
    drawer: SQDrawer([
      CollectionScreen(collection: bookings),
      CollectionScreen(collection: teams),
      CollectionScreen(collection: sports),
      SQProfileScreen(),
    ]),
  );
}

// MVP: Group chat = Private Telegram Group
// MVP: Zoom. View link.
