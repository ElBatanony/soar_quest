// Takedown of Baam on Flutter (BoF)
// https://gitlab.com/markovvn1-iu/f22-ccmdwf/bof

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:soar_quest/soar_quest.dart';
import 'package:soar_quest/src/ui/qr_code_display.dart';

import 'firebase_options.dart';

const challengeFieldName = 'Challenge';
const challengeUpdateSeconds = 3;
const attendeesFieldName = 'Attendees';
const instructorFieldName = 'Instructor';
const sessionIdFieldName = 'Session ID';

late SQCollection sessionsCollection, checkInCollection;

// {"Session ID": "oiMIKDYCtH1BTPDq1qnL", "Challenge": "5"}

void main() async {
  await SQApp.init('SQAAM',
      firebaseOptions: DefaultFirebaseOptions.currentPlatform);

  SQApp.run([Screen('Hello World')]);

  sessionsCollection = LocalCollection(id: 'Sessions', fields: [
    SQStringField('Session Name')..isLive,
    SQCreatedByField(instructorFieldName),
    SQBoolField('Collecting Attendance')
      ..defaultValue = false
      ..show = inFormScreen
      ..isLive = true,
    SQFieldListField(SQStringField(attendeesFieldName)),
    SQStringField(challengeFieldName)
      ..show = falseCond
      ..isLive = true,
  ], actions: [
    GoScreenAction('Resume Check-in', toScreen: SessionCollectionFormScreen.new)
  ]);

  checkInCollection = InMemoryCollection(id: 'Check-in', fields: [
    SQQRCodeField('QR', showStringField: false),
    SQStringField(challengeFieldName),
    SQStringField(sessionIdFieldName),
  ]);

  final sessionsAsInstructor = CollectionSlice(
    sessionsCollection,
    filter: UserFilter(instructorFieldName),
  );

  await sessionsAsInstructor.loadCollection();

  SQApp.run([
    MySessionsCollectionScreen(),
    SessionCollectionScreen(collection: sessionsAsInstructor),
  ], drawer: SQDrawer());
}

class MySessionsCollectionScreen extends CollectionScreen {
  MySessionsCollectionScreen()
      : super(
            collection: sessionsCollection,
            title: 'Attended Sessions',
            icon: Icons.check_circle_outline_outlined) {
    signedIn = true;
  }

  @override
  Widget collectionDisplay(List<SQDoc> docs) => super.collectionDisplay(docs
      .where((doc) =>
          doc
              .getValue<List<String>>(attendeesFieldName)
              ?.contains(SQAuth.user?.email) ??
          false)
      .toList());

  @override
  Widget screenBody() => Column(
        children: [
          SQButton('Attend New Session', onPressed: () async {
            await AttendNewSessionFormScreen(checkInCollection.newDoc())
                .go(context);
            await refresh();
          }),
          super.screenBody(),
        ],
      );
}

class AttendNewSessionFormScreen extends FormScreen {
  AttendNewSessionFormScreen(super.originalDoc) {
    signedIn = true;
  }

  @override
  Future<void> onFieldsChanged(field) async {
    final scannedQR = doc.getValue<String>('QR');
    try {
      final json = jsonDecode(scannedQR ?? '') as Map<String, dynamic>;
      debugPrint('Decoded JSON: $json');
      if (scannedQR != null) doc.parse(json);
      debugPrint('Serialized doc: ${doc.serialize()}');
      final sessionId = doc.getValue<String>('Session ID');
      debugPrint('Session ID $sessionId');
      if (sessionId != null) {
        final sessionDocRef = SQRef(
          collectionPath: sessionsCollection.path,
          docId: sessionId,
        );
        await sessionsCollection.loadCollection();
        final sessionDoc = sessionDocRef.doc;
        final attendees =
            sessionDoc.getValue<List<String>>(attendeesFieldName) ?? [];
        final sessionChallenge =
            sessionDoc.getValue<String>(challengeFieldName);
        final scannedChallenge = doc.getValue<String>(challengeFieldName);

        if (scannedChallenge != sessionChallenge && context.mounted) {
          showSnackBar('Incorrect QR code (challenge)', context: context);
          return;
        }

        final myEmail = SQAuth.user?.email;
        if (myEmail != null) attendees.add(myEmail);
        sessionDoc.setValue(attendeesFieldName, attendees);
        unawaited(sessionsCollection.saveDoc(sessionDoc));
        if (mounted) await DocScreen(sessionDoc).go(context, replace: true);
      } else {
        showSnackBar('Incorrect Session ID', context: context);
      }
    } on Exception {
      showSnackBar('Error processing QR code', context: context);
      return;
    }
    super.onFieldsChanged(field);
  }
}

class SessionCollectionScreen extends CollectionScreen {
  SessionCollectionScreen({required super.collection})
      : super(title: 'Collected Sessions', icon: Icons.list) {
    signedIn = true;
  }

  @override
  screenBody() => SingleChildScrollView(
        child: Column(
          children: [
            SQButton('Collection New Session', onPressed: () async {
              await SessionCollectionFormScreen(collection.newDoc())
                  .go(context);
              await refresh();
            }),
            super.screenBody(),
          ],
        ),
      );

  @override
  floatingActionButton() => null;
}

class SessionCollectionFormScreen extends FormScreen {
  SessionCollectionFormScreen(super.originalDoc) : super(liveEdit: true);

  @override
  Widget screenBody() => SingleChildScrollView(
        child: Column(
          children: [
            if (true == doc.getValue<bool>('Collecting Attendance'))
              SQQRCodeDisplay(
                  string: jsonEncode({
                    sessionIdFieldName: doc.id,
                    challengeFieldName: doc.getValue<String>('Challenge')
                  }),
                  size: 250),
            super.screenBody(),
          ],
        ),
      );

  late Timer timer;

  void updateChallenge() {
    if (doc.getValue<bool>('Collecting Attendance') != true) return;
    doc.setValue(challengeFieldName, timer.tick.toString());
    onFieldsChanged(collection.getField(challengeFieldName)!);
    refresh();
  }

  @override
  void initScreen() {
    timer = Timer.periodic(const Duration(seconds: challengeUpdateSeconds),
        (t) => updateChallenge());
    super.initScreen();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
