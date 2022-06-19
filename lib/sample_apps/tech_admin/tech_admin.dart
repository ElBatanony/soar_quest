import 'package:flutter/material.dart';
import 'package:soar_quest/app/app.dart';
import 'package:soar_quest/data.dart';
import 'package:soar_quest/screens/auth/sign_in_screen.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/main_screen.dart';
import 'package:soar_quest/screens/screen.dart';
import 'package:soar_quest/screens/screen_scaffold.dart';
import 'package:soar_quest/users/auth_manager.dart';
import 'package:soar_quest/users/user_data.dart';

void main() async {
  App adminApp = App("Tech Admin",
      theme: ThemeData(primarySwatch: Colors.amber, useMaterial3: true));

  App.instance.currentUser = UserData(userId: "testuser123");

  final logsCollection = SQCollection(
      "Logs",
      [
        SQDocField("Task Name", SQDocFieldType.string),
        SQDocField("Reminder", SQDocFieldType.string),
        SQDocField("Done", SQDocFieldType.bool, value: false),
      ],
      singleDocName: "Log");

  final logsScreen = CollectionScreen("Logs", logsCollection);

  adminApp.homescreen = MainScreen(
    [
      // AuthScreenTesting("Auth Testing"),
      SignInScreen(
        signedRedirectScreen: ScaffoldedScreen("Yay! You are signed in",
            screenBody: Column(
              children: [SignOutButton()],
            )),
      ),
      Screen("Manage Users"),
      logsScreen,
      Screen("Settings"),
      Screen("Profile")
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
