import 'package:flutter/material.dart';

import 'package:soar_quest/app.dart';
import 'package:soar_quest/components/buttons/sq_button.dart';
import 'package:soar_quest/components/wrappers/special_access_content.dart';
import 'package:soar_quest/data/db.dart';
import 'package:soar_quest/data/types.dart';
import 'package:soar_quest/screens.dart';
import 'package:soar_quest/screens/main_screen.dart';
import 'package:soar_quest/screens/profile_screen.dart';

void main() async {
  List<SQDocField> userDocFields = [
    SQStringField("Telegram Handle"),
    SQStringField("Name"),
    SQBoolField("Admin", readOnly: true),
  ];

  App shicoffeeApp = App("Shicoffee",
      theme: ThemeData(primaryColor: Colors.blue, useMaterial3: true),
      userDocFields: userDocFields);

  await shicoffeeApp.init();

  SQCollection menu = FirestoreCollection(
      id: "Menu",
      fields: [
        SQStringField("Item Name"),
        SQIntField("Item Price"),
      ],
      singleDocName: "Menu Item");

  SQCollection orders = FirestoreCollection(
      id: "Orders",
      fields: [
        SQStringField("Order Note"),
        SQDocReferenceField("Item", collection: menu, readOnly: true),
        SQTimestampField("Time"),
        SQUserRefField("Customer", readOnly: true),
      ],
      singleDocName: "Order");

  shicoffeeApp.homescreen = MainScreen([
    MenuScreen(
      collection: menu,
      ordersCollection: orders,
    ),
    OrdersCollection(collection: orders),
    ProfileScreen(),
  ]);

  shicoffeeApp.run();
}

class MenuScreen extends CollectionScreen {
  final SQCollection ordersCollection;

  MenuScreen(
      {super.title,
      required super.collection,
      required this.ordersCollection,
      super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends CollectionScreenState<MenuScreen> {
  @override
  Widget docDisplay(SQDoc doc) {
    return SQButton(doc.identifier, onPressed: () async {
      if (App.auth.user.isAnonymous) {
        goToScreen(App.auth.signInScreen(), context: context);
        return;
      }
      await goToScreen(
        docCreateScreen(
          widget.ordersCollection,
          hiddenFields: ["Customer"],
          initialFields: [
            SQDocReferenceField(
              "Item",
              collection: doc.collection,
              value: SQDocReference.fromDoc(doc),
            ),
            SQUserRefField("Customer",
                value: SQDocReference.fromDoc(App.auth.user.userDoc)),
          ],
        ),
        context: context,
      );
      refreshScreen();
    });
  }
}

class OrdersCollection extends CollectionScreen {
  OrdersCollection({super.title, required super.collection, super.key});

  @override
  State<OrdersCollection> createState() => _OrdersCollectionState();
}

class _OrdersCollectionState extends CollectionScreenState<OrdersCollection> {
  @override
  Widget screenBody(BuildContext context) {
    return SpecialAccessContent(
        child: super.screenBody(context),
        checker: (userData) {
          return userData.userDoc.getFieldValueByName("Admin") == true;
        });
  }
}
