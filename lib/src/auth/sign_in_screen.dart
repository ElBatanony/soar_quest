import 'package:flutter/material.dart';
import 'sq_auth.dart';

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
    if (widget.forceSignIn == false && SQAuth.user.isAnonymous == false) {
      exitScreen();
    }
    super.initState();
  }

  void signIn() {
    SQAuth.auth
        .signInWithEmailAndPassword(
            email: emailField.value ?? "", password: passwordField.value ?? "")
        .then((_) {
      if (SQAuth.user.isAnonymous) {
        print("Did not sign in");
      } else {
        print("Signed in");
        exitScreen();
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
              SQAuth.auth.signUpScreen().go(context, replace: true),
        )
      ],
    );
  }
}
