import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';

import '../firebase_options.dart';

bool isAdmin = true;

late SQCollection places, bookings;

void main() async {
  await SQApp.init("Safe House",
      theme: ThemeData(primarySwatch: Colors.purple, useMaterial3: true),
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
      CustomAction(
        "Book",
        customExecute: (placeDoc, context) {
          return bookings.saveDoc(bookings.newDoc(initialFields: [
            SQRefField("Place", collection: places, value: placeDoc.ref),
            SQUserRefField("Tenant", value: SQUserRefField.currentUserRef),
            SQUserRefField("Host", value: placeDoc.value("Host"))
          ]));
        },
      )
    ],
    readOnly: !isAdmin,
  );

  bookings = FirestoreCollection(
      id: "Bookings",
      fields: [
        SQRefField("Place", collection: places),
        SQUserRefField("Host"),
        SQUserRefField("Tenant"),
        SQEditedByField("Booking User"),
        SQBoolField("Accepted", value: false),
      ],
      actions: [
        SetFieldsAction("Accept",
            show: DocValueCond("Accepted", false) &
                DocValueCond("Host", SQUserRefField.currentUserRef),
            getFields: (doc) => {"Accepted": true})
      ],
      readOnly: true);

  CollectionSlice myBookings = CollectionSlice(bookings,
      filter: DocRefFilter("Tenant", SQUserRefField.currentUserRef));

  SQApp.run(
    [
      CollectionScreen(collection: places),
      CollectionScreen(collection: myBookings),
    ],
    drawer: SQDrawer([CollectionScreen(collection: bookings)]),
  );
}
