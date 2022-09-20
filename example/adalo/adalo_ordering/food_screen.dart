import 'package:flutter/material.dart';
import 'package:soar_quest/app/app_navigator.dart';
import 'package:soar_quest/components/buttons/sq_button.dart';
import 'package:soar_quest/data/db/sq_doc.dart';
import 'package:soar_quest/data/docs_filter.dart';
import 'package:soar_quest/data/types/sq_doc_reference.dart';
import 'package:soar_quest/screens.dart';

import 'config_adalo_ordering.dart';

class FoodScreen extends CollectionFilterScreen {
  FoodScreen({super.key})
      : super(
            title: "Food",
            collection: foodTrucks,
            filters: [StringContainsFilter(foodTrucks.getFieldByName("Name"))]);

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends CollectionFilterScreenState<FoodScreen> {
  @override
  Widget docDisplay(SQDoc doc) {
    return CollectionScreen(
      collection: menuItems,
      canCreate: isAdmin,
      filters: [
        DocRefFilter("Food Truck", SQDocRef.fromDoc(doc)),
      ],
      prebody: (context) => SQButton("Start Order",
          onPressed: () => goToScreen(startOrderScreen(doc), context: context)),
    ).button(context, label: doc.identifier);
  }
}

DocFormScreen startOrderScreen(SQDoc foodTruckDoc) {
  return docCreateScreen(orders, initialFields: [
    orders.getFieldByName("Food Truck").copy()
      ..value = SQDocRef.fromDoc(foodTruckDoc)
      ..readOnly = true,
  ], shownFields: [
    "Food Truck",
    "Pick up time"
  ]);
}
