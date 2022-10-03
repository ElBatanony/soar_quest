import 'package:flutter/material.dart';
import 'package:soar_quest/app.dart';
import 'package:soar_quest/screens.dart';

import 'config_adalo_ordering.dart';
import 'food_screen.dart';

void main() async {
  App adaloOrderingApp = App("Food Spot",
      theme: ThemeData(primarySwatch: Colors.purple, useMaterial3: true),
      userDocFields: userDocFields);

  await adaloOrderingApp.init();

  configCollections();

  adaloOrderingApp.run(MainScreen([
    FoodScreen(),
    if (isAdmin) CollectionScreen(collection: foodTrucks, canCreate: true),
    if (isAdmin) CollectionScreen(collection: menuItems, canCreate: true),
    CollectionScreen(collection: orders),
    ProfileScreen(),
  ]));
}
