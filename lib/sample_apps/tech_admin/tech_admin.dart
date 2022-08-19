import 'package:flutter/material.dart';
import 'package:soar_quest/app/app.dart';
import 'package:soar_quest/app/app_settings.dart';
import 'package:soar_quest/data.dart';
import 'package:soar_quest/data/firestore.dart';
import 'package:soar_quest/screens/cloud_function_docs_screen.dart';
import 'package:soar_quest/screens/collection_filter_screen.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/main_screen.dart';
import 'package:soar_quest/screens/screen.dart';
import 'package:soar_quest/screens/settings_screen.dart';
import 'package:soar_quest/users/auth_manager.dart';
import 'package:soar_quest/users/user_data.dart';

import '../../data/docs_filter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  App adminApp = App("Tech Admin",
      theme: ThemeData(primarySwatch: Colors.amber, useMaterial3: true),
      inDebug: false,
      emulatingCloudFunctions: false);

  await adminApp.init();

  App.instance.currentUser = UserData(userId: "testuser123");

  final logsCollection = FirestoreCollection(
      id: "Logs",
      fields: [
        SQDocField("logId", SQDocFieldType.string),
        SQDocField("message", SQDocFieldType.string),
        SQDocField("date", SQDocFieldType.timestamp),
        SQDocField("payload", SQDocFieldType.bool),
        // SQDocField("tags", SQDocFieldType.string),
      ],
      singleDocName: "Log");

  final logsScreen = CollectionScreen("Logs", logsCollection);

  AppSettings.setSettings([
    SQDocField('fawryCodeRequest', SQDocFieldType.bool),
    SQDocField('userIdUploaded', SQDocFieldType.bool),
    SQDocField('paymentError', SQDocFieldType.bool),
    SQDocField('newUser', SQDocFieldType.bool),
    SQDocField('payment', SQDocFieldType.bool),
    SQDocField('manualMembership', SQDocFieldType.bool),
    SQDocField('username', SQDocFieldType.string),
    SQDocField('Log Manual Commands', SQDocFieldType.bool),
  ]);

  DocsFilter logIdSearchField =
      StringContainsFilter(logsCollection.getFieldByName("logId"));
  DocsFilter payloadFilter =
      DocsFilter(logsCollection.getFieldByName("payload"));

  adminApp.homescreen = MainScreen(
    [
      // AuthScreenTesting("Auth Testing"),
      // SignInScreen(
      //   signedRedirectScreen: ScaffoldedScreen("Yay! You are signed in",
      //       screenBody: Column(
      //         children: [SignOutButton()],
      //       )),
      // ),
      CollectionFilterScreen(
        "Search",
        collection: logsCollection,
        filters: [logIdSearchField, payloadFilter],
      ),
      SettingsScreen(),
      CloudFunctionDocsScreen(
        "Fetched Logs",
        collection: logsCollection,
      ),
      logsScreen,
      // Screen("Manage Users"),
      // PlaygroundScreen("Playground")
    ],
    initialScreenIndex: 0,
  );

  adminApp.run();
}

class AuthScreenTesting extends Screen {
  AuthScreenTesting(String title, {Key? key}) : super(title, key: key);

  @override
  State<AuthScreenTesting> createState() => _AuthScreenTestingState();
}

class _AuthScreenTestingState extends State<AuthScreenTesting> {
  @override
  Widget build(BuildContext context) {
    return Text("Text");
  }
}

class SignOutButton extends StatelessWidget {
  const SignOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: AuthManager.signOut, child: Text("Sign Out"));
  }
}
