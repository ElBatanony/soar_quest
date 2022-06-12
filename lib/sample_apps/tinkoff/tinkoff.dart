// ignore_for_file: unused_local_variable

import 'package:soar_quest/app/app.dart';
import 'package:soar_quest/data/sq_collection.dart';
import 'package:soar_quest/data/sq_doc.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/doc_screen.dart';
import 'package:soar_quest/screens/menu_screen.dart';
import 'package:soar_quest/screens/screen.dart';
import 'package:soar_quest/users/user_data.dart';

void main() async {
  App tinkoffApp = App("Tinkoff");
  App.instance.currentUser = UserData(userId: "testuser123");

  final cashbackEarnedData = SQDoc(
      'cashbackEarned',
      [
        SQDocField("cashbackEarned", SQDocFieldType.int),
        SQDocField("creditedOn", SQDocFieldType.string)
      ],
      collection: userCollection);

  final cashbackEarnedScreen = DocScreen(
    "Cashback Earned",
    cashbackEarnedData,
    refreshCollectionScreen: () {},
  );

  final partnerCashbackCol = SQCollection("partner-cashbacks", [
    SQDocField("Partner", SQDocFieldType.string),
    SQDocField("Headline", SQDocFieldType.string),
    SQDocField("Subheader", SQDocFieldType.string)
  ]);

  final partnerCashbackScreen =
      CollectionScreen("Partner Cashbacks", partnerCashbackCol);

  final MenuScreen cashbackBonusesScreen = MenuScreen("Bonuses", [
    cashbackEarnedScreen,
    const Screen("How to get bonuses"),
    partnerCashbackScreen,
    Screen("Partner subscriptions"),
    Screen("Increased caschback at month")
  ]);

  final MenuScreen homescreen = MenuScreen("Tinkoff Homescreen",
      [Screen("Profile"), Screen('Payments'), cashbackBonusesScreen]);
  tinkoffApp.homescreen = homescreen;

  tinkoffApp.run();
}
