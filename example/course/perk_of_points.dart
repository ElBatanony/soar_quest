import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';
import 'package:soar_quest/src/db/fields/sq_url_field.dart';

late SQCollection games, gameInstances, players, rounds;

void main() async {
  await SQApp.init("Perk of Points",
      theme: ThemeData(primaryColor: Colors.yellow, useMaterial3: true));

  games = LocalCollection(id: "Games", fields: [
    SQStringField("Name"),
    SQLinkField("Rules Link"),
  ], actions: [
    GoDerivedDocAction("Start Game",
        getCollection: () => gameInstances,
        form: false,
        initialFields: (gameDoc) => [
              SQRefField("Game",
                  collection: games, value: gameDoc.ref, editable: false)
            ])
  ]);

  gameInstances = LocalCollection(
    id: "Game Instances",
    fields: [
      SQRefField("Game", collection: games),
      SQRefDocsField("Players",
          refCollection: () => players, refFieldName: "Game"),
      SQRefDocsField("Rounds",
          refCollection: () => rounds, refFieldName: "Game"),
    ],
    updates: false,
    actions: [
      GoDerivedDocAction("Add Player",
          getCollection: () => players,
          initialFields: (gameInstanceDoc) => [
                SQRefField("Game",
                    collection: gameInstances,
                    value: gameInstanceDoc.ref,
                    editable: false),
              ]),
      GoDerivedDocAction("Start Round",
          getCollection: () => rounds,
          initialFields: (gameInstanceDoc) => [
                SQRefField("Game",
                    collection: gameInstances,
                    value: gameInstanceDoc.ref,
                    editable: false),
                SQRefField(
                  "Player",
                  collection: CollectionSlice(players,
                      filter: DocRefFilter("Game", gameInstanceDoc.ref)),
                ),
                SQIntField("Points", editable: false, value: 0),
              ]),
    ],
  );

  players = LocalCollection(
    id: "Players",
    fields: [
      SQStringField("Player Name"),
      SQRefField("Game", collection: gameInstances),
      SQVirtualField(
          field: SQIntField("Points", value: 0),
          valueBuilder: (playerDoc) {
            int points = 0;
            List<SQDoc> playerRounds = rounds.docs
                .where((round) => round.value<SQRef>("Player") == playerDoc.ref)
                .toList();
            for (final playerRound in playerRounds) {
              points += playerRound.value<int>("Points") ?? 0;
            }
            return points;
          })
    ],
    actions: [
      // GoDerivedDocAction("Start Round",
      //     getCollection: () => rounds,
      //     form: false,
      //     initialFields: (playerDoc) => [
      //           SQRefField("Game",
      //               collection: gameInstances,
      //               value: playerDoc.value<SQRef>("Game")),
      //           SQRefField("Player", collection: players, value: playerDoc.ref),
      //         ])
    ],
  );

  rounds = LocalCollection(id: "Rounds", fields: [
    SQRefField("Game", collection: gameInstances),
    SQRefField("Player", collection: players),
    SQIntField("Points", value: 0),
  ], actions: [
    SetFieldsAction("1",
        getFields: (roundDoc) =>
            {"Points": (roundDoc.value<int>("Points") ?? 0) + 1}),
    CustomAction("Finish Round",
        customExecute: (doc, context) async =>
            ScreenState.of(context).exitScreen()),
  ]);

  SQApp.run(
    SQNavBar([
      CollectionScreen(collection: games),
      CollectionScreen(collection: gameInstances),
    ]),
  );
}
