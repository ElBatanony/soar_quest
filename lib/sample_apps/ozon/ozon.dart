// ignore_for_file: unused_local_variable, unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:soar_quest/app/app.dart';
import 'package:soar_quest/app/app_display.dart';
import 'package:soar_quest/data/sq_collection.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/firebase_options.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/doc_screen.dart';
import 'package:soar_quest/screens/main_screen.dart';
import 'package:soar_quest/screens/menu_screen.dart';
import 'package:soar_quest/screens/screen.dart';
import 'package:soar_quest/users/user_data.dart';

void main() async {
  App ozonApp = App("Ozon");
  App.instance.currentUser = UserData(userId: "testuser123");

  final catalogueCollection = SQCollection([
    SQDocField("Item Name", SQDocFieldType.string),
    SQDocField("Item Price", SQDocFieldType.int),
  ], "catalogue");

  Widget catalogueObjectDisplayBody(SQDoc object) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
      Text("this is the custom diplay of the ozon catalogue item"),
      ElevatedButton(onPressed: null, child: Text("add to favourites")),
      Text("custom display")
    ]
        // object.fields.map((field) => DataFieldDisplay(field)).toList()
        );
  }

  final catalogueScreen = CollectionScreen(
    "Catalogue",
    catalogueCollection,
    dataObjectDisplayBody: catalogueObjectDisplayBody,
  );

  final MainScreen homescreen = MainScreen(
    [
      Screen("Main"),
      Screen('Fresh'),
      catalogueScreen,
      Screen('Cart'),
      Screen('Favourites')
    ],
    initialScreenIndex: 2,
  );
  ozonApp.homescreen = homescreen;

  ozonApp.run();
}
