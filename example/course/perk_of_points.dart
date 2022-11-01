import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';
import 'package:soar_quest/src/db/fields/sq_url_field.dart';

late SQCollection games, gameInstances, players, rounds;

void main() async {
  await SQApp.init("Perk of Points",
      theme: ThemeData(primarySwatch: Colors.yellow, useMaterial3: true));

  games = LocalCollection(id: "Games", fields: [
    SQStringField("Name"),
    SQLinkField("Rules Link"),
  ], actions: [
    CreateDocAction("Start Game",
        getCollection: () => gameInstances,
        form: false,
        goBack: false,
        initialFields: (gameDoc) => [
              SQRefField("Game",
                  collection: games, value: gameDoc.ref, editable: false)
            ])
  ]);

  gameInstances = InMemoryCollection(
      id: "Game Instances",
      fields: [
        SQRefField("Game", collection: games),
        SQInverseRefsField("Players",
            refCollection: () => players, refFieldName: "Game"),
        SQInverseRefsField("Rounds",
            refCollection: () => rounds, refFieldName: "Game"),
      ],
      updates: false);

  players = InMemoryCollection(
    id: "Players",
    fields: [
      SQStringField("Player Name"),
      SQRefField("Game", collection: gameInstances),
      SQVirtualField(
          field: SQIntField("Points", value: 0),
          valueBuilder: (playerDoc) {
            int points = 0;
            List<SQDoc> playerRounds = rounds.docs
                .where((round) =>
                    round.value<SQRef>("Player") == playerDoc.ref &&
                    round.value<SQRef>("Game") ==
                        playerDoc.value<SQRef>("Game"))
                .toList();
            for (final playerRound in playerRounds) {
              points += playerRound.value<int>("Points") ?? 0;
            }
            return points;
          })
    ],
  );

  final unoPoints = {'1': 1, '2': 2, '3': 3, 'Super': 10, 'Duper': 20};

  rounds = InMemoryCollection(id: "Rounds", fields: [
    SQRefField("Game", collection: gameInstances),
    SQRefField("Player", collection: players),
    SQIntField("Points", value: 0, editable: false),
  ], actions: [
    ...unoPoints.entries
        .map((pointEntry) => SetFieldsAction(pointEntry.key,
            getFields: (roundDoc) => {
                  "Points":
                      (roundDoc.value<int>("Points") ?? 0) + pointEntry.value
                }))
        .toList(),
    CustomAction("Finish Round",
        customExecute: (doc, context) async =>
            ScreenState.of(context).exitScreen()),
  ]);

  SQApp.run([CollectionScreen(collection: games)]);
}
