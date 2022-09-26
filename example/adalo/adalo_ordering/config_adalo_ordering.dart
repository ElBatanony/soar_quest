import 'package:soar_quest/data/db.dart';

const isAdmin = true;

List<SQDocField> userDocFields = [
  SQStringField("Full Name"),
  SQFileField("Profile Picture"),
];

SQCollection foodTrucks = FirestoreCollection(
  id: "Food Trucks",
  fields: [
    SQStringField("Name"),
    SQStringField("Hours"),
    SQInverseRefField("Menu Items", refFieldName: "Food Truck"),
  ],
  readOnly: !isAdmin,
  singleDocName: "Food Truck",
);

SQCollection menuItems = FirestoreCollection(
    id: "Menu Items",
    fields: [
      SQStringField("Name"),
      SQDocRefField("Food Truck", collection: foodTrucks),
      SQDoubleField("Price"),
      SQBoolField("Food?", value: true),
      SQBoolField("Drink?"),
    ],
    singleDocName: "Menu Item");

SQCollection orders = FirestoreCollection(
    id: "Orders",
    fields: [
      SQCreatedByField("User"),
      SQDocRefField("Food Truck", collection: foodTrucks),
      SQTimeOfDayField("Pick up time"),
      // SQRefListField("Order Items", collection: orderItems),
      // TODO : add order items

      SQStringField("Notes"),
      SQStringField("Status"),
      SQDoubleField("Tip Amount"),
      SQDoubleField("Total Paid"),
    ],
    singleDocName: "Order");

SQCollection orderItems = FirestoreCollection(
    id: "Order Items",
    fields: [
      SQStringField("Name"),
      SQDocRefField("Menu Item", collection: menuItems),
      SQDocRefField("Order", collection: orders),
      SQDoubleField("Price"),
    ],
    singleDocName: "Order Item");
