import 'package:soar_quest/data/db.dart';

const isAdmin = true;

List<SQDocField> userDocFields = [
  SQStringField("Full Name"),
  SQFileField("Profile Picture"),
];

late MenuItemsCollection menuItems;

class MenuItemDoc extends SQDoc {
  String get name => getFieldValueByName("Name");
  double get price => getFieldValueByName("Price");
  SQDocRef get foodTruck => getFieldValueByName("Food Truck");
  bool get isFood => getFieldValueByName("Food?");
  bool get isDrink => getFieldValueByName("Drink?");

  MenuItemDoc(super.id, {required super.collection});
}

class MenuItemsCollection extends FirestoreCollection<MenuItemDoc> {
  MenuItemsCollection({required super.id})
      : super(
          fields: [
            SQStringField("Name"),
            SQDocRefField("Food Truck", collectionId: foodTrucks.id),
            SQDoubleField("Price"),
            SQBoolField("Food?", value: true),
            SQBoolField("Drink?")
          ],
          singleDocName: "Menu Item",
        );

  @override
  MenuItemDoc constructDoc(String id) {
    return MenuItemDoc(id, collection: this);
  }
}

void configCollections() {
  foodTrucks = FirestoreCollection(
    id: "Food Trucks",
    fields: [
      SQStringField("Name", required: true),
      SQStringField("Hours"),
      SQInverseRefField("Menu Items",
          refFieldName: "Food Truck", collectionId: "Menu Items"),
      SQFieldListField("List Test", allowedTypes: [
        SQStringField(""),
        SQTimestampField(""),
        SQFileField(""),
        SQDocRefField("", collectionId: "Menu Items"),
        SQDocRefField("", collectionId: "Orders"),
      ])
    ],
    readOnly: !isAdmin,
    singleDocName: "Food Truck",
  );

  menuItems = MenuItemsCollection(id: "Menu Items");

  orders = FirestoreCollection(
      id: "Orders",
      fields: [
        SQCreatedByField("User"),
        SQDocRefField("Food Truck", collectionId: foodTrucks.id),
        SQTimeOfDayField("Pick up time"),
        // SQRefListField("Order Items", collection: orderItems),
        // TODO : add order items

        SQStringField("Notes"),
        SQStringField("Status"),
        SQDoubleField("Tip Amount"),
        SQDoubleField("Total Paid"),
      ],
      singleDocName: "Order");

  orderItems = FirestoreCollection(
      id: "Order Items",
      fields: [
        SQStringField("Name"),
        SQDocRefField("Menu Item", collectionId: menuItems.id),
        SQDocRefField("Order", collection: orders),
        SQDoubleField("Price"),
      ],
      singleDocName: "Order Item");
}
