import 'package:flutter/material.dart';
import 'package:soar_quest/app.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/main_screen.dart';
import 'package:soar_quest/screens/profile_screen.dart';

import 'config_adalo_ordering.dart';
import 'food_screen.dart';

void main() async {
  App adaloOrderingApp = App("Food Spot",
      theme: ThemeData(primarySwatch: Colors.purple, useMaterial3: true),
      userDocFields: userDocFields);

  await adaloOrderingApp.init();

  configCollections();

  adaloOrderingApp.homescreen = MainScreen([
    if (isAdmin) CollectionScreen(collection: foodTrucks, canCreate: isAdmin),
    FoodScreen(),
    CollectionScreen(collection: orders),
    ProfileScreen(),
  ]);

  adaloOrderingApp.run();
}
