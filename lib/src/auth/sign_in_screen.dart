import 'package:flutter/material.dart';

import '../sq_app.dart';
import '../db/fields/sq_string_field.dart';
import '../ui/sq_button.dart';
import '../screens/screen.dart';

class SignInScreen extends Screen {
  final bool forceSignIn;

  const SignInScreen({
    String title = "Sign In",
    this.forceSignIn = false,
    Key? key,
  }) : super(title, key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ScreenState<SignInScreen> {
  final emailField = SQStringField("Email", value: "test@email.com");
  final passwordField = SQStringField("Password", value: "testtest");

  @override
  void initState() {
    if (widget.forceSignIn == false && SQApp.auth.user.isAnonymous == false) {
      exitScreen(context);
    }
    super.initState();
  }

  signIn() {
    SQApp.auth
        .signInWithEmailAndPassword(
            email: emailField.value ?? "", password: passwordField.value ?? "")
        .then((_) {
      if (SQApp.auth.user.isAnonymous) {
        print("Did not sign in");
      } else {
        print("Signed in");
        exitScreen(context);
      }
    });
  }

  @override
  Widget screenBody(BuildContext context) {
    return Column(
      children: [
        emailField.formField(),
        passwordField.formField(),
        SQButton("Sign In", onPressed: signIn),
        SQButton(
          "Sign Up",
          onPressed: () =>
              replaceScreen(SQApp.auth.signUpScreen(), context: context),
        )
      ],
    );
  }
}
