// import 'package:soar_quest/db.dart';

// const isAdmin = true;

// List<SQDocField> userDocFields = [
//   SQStringField("Full Name"),
//   SQFileField("Profile Picture"),
// ];

// late SQCollection foodTrucks, orders;

// late MenuItemsCollection menuItems;

// class MenuItemDoc extends SQDoc {
//   String get name => value("Name");
//   double get price => value("Price");
//   SQDocRef get foodTruck => value("Food Truck");
//   bool get isFood => value("Food?");
//   bool get isDrink => value("Drink?");

//   MenuItemDoc(super.id, {required super.collection});
// }

// class MenuItemsCollection extends FirestoreCollection<MenuItemDoc> {
//   MenuItemsCollection({required super.id})
//       : super(
//           fields: [
//             SQStringField("Name"),
//             SQDocRefField("Food Truck", collection: foodTrucks),
//             SQDoubleField("Price"),
//             SQBoolField("Food?", value: true),
//             SQBoolField("Drink?")
//           ],
//           singleDocName: "Menu Item",
//         );

//   @override
//   MenuItemDoc constructDoc(String id) {
//     return MenuItemDoc(id, collection: this);
//   }
// }

// void configCollections() {
//   foodTrucks = FirestoreCollection(
//     id: "Food Trucks",
//     fields: [
//       SQStringField("Name", required: true),
//       SQStringField("Hours"),
//     ],
//     readOnly: !isAdmin,
//     singleDocName: "Food Truck",
//   );

//   menuItems = MenuItemsCollection(id: "Menu Items");

//   foodTrucks.fields.add(SQInverseRefField("Menu Items",
//       refFieldName: "Food Truck", collection: menuItems));

//   orders = FirestoreCollection(
//       id: "Orders",
//       fields: [
//         SQCreatedByField("User"),
//         SQDocRefField("Food Truck", collection: foodTrucks, readOnly: true),
//         SQTimeOfDayField("Pick up time"),
//         SQFieldListField("Order Items", allowedTypes: []),
//         SQStringField("Notes"),
//         SQStringField("Status", readOnly: true),
//         SQDoubleField("Tip Amount"),
//         SQDoubleField("Total Paid", readOnly: true),
//       ],
//       singleDocName: "Order");
// }
