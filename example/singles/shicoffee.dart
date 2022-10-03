import 'package:flutter/material.dart';

import 'package:soar_quest/app.dart';
import 'package:soar_quest/components/buttons/sq_button.dart';
import 'package:soar_quest/components/wrappers/special_access_content.dart';
import 'package:soar_quest/db.dart';
import 'package:soar_quest/data/types.dart';
import 'package:soar_quest/screens.dart';

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
        SQDocRefField("Item", collection: menu, readOnly: true),
        SQTimestampField("Time"),
        SQUserRefField("Customer", readOnly: true),
      ],
      singleDocName: "Order");

  shicoffeeApp.run(MainScreen([
    MenuScreen(
      collection: menu,
      ordersCollection: orders,
    ),
    OrdersCollection(collection: orders),
    ProfileScreen(),
  ]));
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
            SQDocRefField(
              "Item",
              collection: doc.collection,
              value: SQDocRef.fromDoc(doc),
            ),
            SQUserRefField("Customer",
                value: SQDocRef.fromDoc(App.auth.user.userDoc)),
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
          return userData.userDoc.value("Admin") == true;
        });
  }
}
