import 'package:flutter/material.dart';
import 'package:soar_quest/app/app.dart';
import 'package:soar_quest/app/app_settings.dart';
import 'package:soar_quest/data.dart';
import 'package:soar_quest/data/firestore.dart';
import 'package:soar_quest/screens/category_select_screen.dart';
// import 'package:soar_quest/screens/cloud_function_docs_screen.dart';
import 'package:soar_quest/screens/collection_filter_screen.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/main_screen.dart';
import 'package:soar_quest/screens/screen.dart';
// import 'package:soar_quest/screens/settings_screen.dart';
import 'package:soar_quest/users/auth_manager.dart';
import 'package:soar_quest/users/user_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  App adminApp = App("Tech Admin",
      theme: ThemeData(primarySwatch: Colors.amber, useMaterial3: true),
      inDebug: false,
      emulatingCloudFunctions: false);

  await adminApp.init();

  App.instance.currentUser = UserData(userId: "testuser123");

  final coloursCollection = FirestoreCollection(
      id: "Colours",
      fields: [
        SQStringField("name"),
        SQStringField("hexValue"),
      ],
      singleDocName: "Colour");

  final logsColourField = SQStringField("colour");
  final colorRefField = SQDocReferenceField("colorDoc",
      value: SQDocReference(collection: coloursCollection));

  final logsCollection = FirestoreCollection(
      id: "Logs",
      fields: [
        SQStringField("logId"),
        // SQDocField("message", SQDocFieldType.string),
        SQTimestampField("date"),
        SQBoolField("payload"),
        // SQDocListField("tags"),
        colorRefField,
        logsColourField,
        // SQDocListField("colours"),
      ],
      singleDocName: "Log");

  final otherLogRefField = SQDocReferenceField("otherLogDoc",
      value: SQDocReference(collection: logsCollection));

  logsCollection.fields.add(otherLogRefField);

  AppSettings.setSettings([
    SQBoolField('paymentError'),
    SQBoolField('newUser'),
    SQBoolField('payment'),
    SQStringField('username'),
    SQBoolField('Log Manual Commands'),
  ]);

  DocsFilter logIdSearchField =
      StringContainsFilter(logsCollection.getFieldByName("logId"));
  DocsFilter payloadFilter =
      DocsFilter(logsCollection.getFieldByName("payload"));

  final logsScreen = CollectionScreen("Logs", collection: logsCollection);

  adminApp.homescreen = MainScreen(
    [
      // AuthScreenTesting("Auth Testing"),
      // SignInScreen(
      //   signedRedirectScreen: ScaffoldedScreen("Yay! You are signed in",
      //       screenBody: Column(
      //         children: [SignOutButton()],
      //       )),
      // ),
      logsScreen,
      CollectionScreen("Colours", collection: coloursCollection),
      // CollectionScreen("Logs", logsCollection),
      CategorySelectScreen(
        "Colour Cat",
        collection: logsCollection,
        categoryCollection: coloursCollection,
        categoryField: logsColourField,
      ),
      CollectionFilterScreen(
        "Search",
        collection: logsCollection,
        filters: [logIdSearchField, payloadFilter],
      ),
      // SettingsScreen(),
      // CloudFunctionDocsScreen(
      //   "Fetched Logs",
      //   collection: logsCollection,
      // ),
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
