import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../components/buttons/sq_button.dart';
import '../../../data/fields.dart';
import '../../../screens.dart';

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
    if (widget.forceSignIn == false && App.auth.user.isAnonymous == false) {
      exitScreen(context);
    }
    super.initState();
  }

  signIn() {
    App.auth
        .signInWithEmailAndPassword(
            email: emailField.value, password: passwordField.value)
        .then((_) {
      if (App.auth.user.isAnonymous) {
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
              replaceScreen(App.auth.signUpScreen(), context: context),
        )
      ],
    );
  }
}
