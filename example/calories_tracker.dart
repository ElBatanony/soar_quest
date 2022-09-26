import 'package:flutter/material.dart';

import 'package:soar_quest/app.dart';
import 'package:soar_quest/data/db.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/main_screen.dart';
import 'package:soar_quest/screens/profile_screen.dart';

void main() async {
  List<SQDocField> userDocFields = [
    SQStringField("Full Name"),
    SQBoolField("isAdmin"),
    SQIntField("Daily Calrie Limit"),
    SQDoubleField("Monthly Expenses"),
  ];

  App caloriesTrackersApp = App("To Do List",
      theme: ThemeData(primaryColor: Colors.blue, useMaterial3: true),
      authManager: FirebaseAuthManager(),
      userDocFields: userDocFields);

  await caloriesTrackersApp.init();

  SQCollection meals = FirestoreCollection(id: "Meals", fields: [
    SQStringField("Name"),
    SQIntField("Calories"),
    SQDoubleField("Price"),
    SQTimestampField("Timestamp"),
    SQCreatedByField("User"),
  ]);

  caloriesTrackersApp.homescreen = MainScreen([
    MealCollectionScreen(
      collection: meals,
      filters: [
        CompareFuncFilter(SQTimestampField("Timestamp"),
            compareFunc: (p) => p < 0)
      ],
    ),
    ProfileScreen(),
  ]);

  caloriesTrackersApp.run();
}

class MealCollectionScreen extends CollectionFilterScreen {
  MealCollectionScreen(
      {super.title,
      required super.collection,
      required super.filters,
      super.key})
      : super(canCreate: true);

  @override
  State<MealCollectionScreen> createState() => _MealCollectionScreenState();
}

class _MealCollectionScreenState
    extends CollectionFilterScreenState<MealCollectionScreen> {
  @override
  Widget docDisplay(SQDoc doc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(doc.getFieldValueByName("Name")),
            Text(doc.getFieldValueByName("Calories").toString()),
            Text(doc.getFieldValueByName("Price").toString())
          ],
        ),
      ),
    );
  }
}
