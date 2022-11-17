import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';

import '../firebase_options.dart';

bool isAdmin = true;

late SQCollection places, bookings;

void main() async {
  await SQApp.init("Safe Kiva",
      theme: ThemeData(primarySwatch: Colors.red, useMaterial3: true),
      userDocFields: [
        SQBoolField("Speaks English"),
        SQBoolField("Speaks Russian")
      ],
      firebaseOptions: DefaultFirebaseOptions.currentPlatform);

  places = FirestoreCollection(
    id: "Places",
    fields: [
      SQStringField("Place Name"),
      SQImageField("Picture"),
      SQEditedByField("Host"),
    ],
    actions: [
      CreateDocAction("Book",
          getCollection: () => bookings,
          show: isSignedIn,
          initialFields: (placeDoc) => [
                SQRefField("Place", collection: places, value: placeDoc.ref),
                SQUserRefField("Tenant", value: SQAuth.userDoc!.ref),
                SQUserRefField("Host", value: placeDoc.value("Host"))
              ]),
    ],
  );

  bookings = FirestoreCollection(
    id: "Bookings",
    fields: [
      SQRefField("Place", collection: places),
      SQStringField("Status",
          value: "Pending", editable: false, show: inFormScreen.not),
      SQUserRefField("Host"),
      SQUserRefField("Tenant", editable: false),
      SQEditedByField("Booking User"),
    ],
    actions: [
      SetFieldsAction("Accept",
          show: DocValueCond("Status", "Pending") & DocUserCond("Host"),
          getFields: (doc) => {"Status": "Accepted"})
    ],
    updates: SQUpdates.readOnly(),
  );

  CollectionSlice myBookings =
      CollectionSlice(bookings, filter: UserFilter("Tenant"));

  SQApp.run(
    [
      CollectionScreen(collection: places),
      CollectionScreen(title: "My Bookings", collection: myBookings),
    ],
    drawer: SQDrawer([CollectionScreen(collection: bookings)]),
  );
}
