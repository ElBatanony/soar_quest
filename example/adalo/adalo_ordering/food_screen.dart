import 'package:flutter/material.dart';
import 'package:soar_quest/app.dart';
import 'package:soar_quest/ui.dart';
import 'package:soar_quest/db.dart';
import 'package:soar_quest/screens.dart';

import 'config_adalo_ordering.dart';
import 'order_form.dart';

class FoodScreen extends CollectionFilterScreen {
  FoodScreen({super.key})
      : super(title: "Food", collection: foodTrucks, filters: [
          StringContainsFilter(foodTrucks.getFieldByName("Name")!),
        ]);

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends CollectionFilterScreenState<FoodScreen> {
  void goToOrderFormScreen(SQDoc foodTruckDoc) {
    SQDoc newOrderDoc = orders.newDoc(initialFields: [
      SQDocRefField("Food Truck",
          value: SQDocRef.fromDoc(foodTruckDoc),
          collection: foodTrucks,
          readOnly: true),
    ]);

    goToScreen(OrderFormScreen(newOrderDoc, submitFunction: updateItem),
        context: context);
  }

  @override
  Widget docDisplay(SQDoc doc) {
    return CollectionScreen(
      collection: menuItems,
      canCreate: isAdmin,
      filters: [
        DocRefFilter("Food Truck", SQDocRef.fromDoc(doc)),
      ],
      prebody: (context) =>
          SQButton("Start Order", onPressed: () => goToOrderFormScreen(doc)),
    ).button(context, label: doc.identifier);
  }
}
