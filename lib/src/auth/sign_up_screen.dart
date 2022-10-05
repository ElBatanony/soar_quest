import 'package:flutter/material.dart';

import '../app/app.dart';
import '../db/fields/sq_string_field.dart';
import '../ui/sq_button.dart';
import '../screens/screen.dart';

class SQSignUpScreen extends Screen {
  final bool forceSignIn;

  const SQSignUpScreen({
    String title = "Sign Up",
    this.forceSignIn = false,
    Key? key,
  }) : super(title, key: key);

  @override
  State<SQSignUpScreen> createState() => _SQSignUpScreenState();
}

class _SQSignUpScreenState extends ScreenState<SQSignUpScreen> {
  final emailField = SQStringField("Email", value: "test@email.com");
  final passwordField = SQStringField("Password", value: "testtest");

  @override
  void initState() {
    if (widget.forceSignIn == false && App.auth.user.isAnonymous == false) {
      redirect();
    }
    super.initState();
  }

  redirect() {
    exitScreen(context);
  }

  @override
  Widget screenBody(BuildContext context) {
    return Column(
      children: [
        emailField.formField(),
        passwordField.formField(),
        SQButton("Sign Up", onPressed: () async {
          await App.auth.signUpWithEmailAndPassword(
              email: emailField.value ?? "",
              password: passwordField.value ?? "");
          if (App.auth.user.isAnonymous) {
            print("Did not sign in");
          } else {
            print("Signed in");
            redirect();
          }
        }),
        SQButton(
          "Sign In",
          onPressed: () =>
              replaceScreen(App.auth.signInScreen(), context: context),
        )
      ],
    );
  }
}
