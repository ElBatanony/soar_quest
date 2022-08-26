import 'package:flutter/material.dart';
import 'package:soar_quest/screens/screen.dart';
import 'package:soar_quest/screens/screen_scaffold.dart';
import 'package:soar_quest/users/auth_manager.dart';

class SignInScreen extends Screen {
  final Screen signedRedirectScreen;

  const SignInScreen(
      {String title = "Sign In", required this.signedRedirectScreen, Key? key})
      : super(title, key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
        stream: AuthManager.authChanges,
        builder: (context, snapshot) {
          return snapshot.data?["signedIn"] == true
              ? widget.signedRedirectScreen
              : ScreenScaffold(
                  widget.title,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sign In Screen"),
                      ElevatedButton(
                          onPressed: AuthManager.signInAnonymously,
                          child: Text("Sign In Anonymously"))
                    ],
                  ));
        });
  }
}
