import 'package:flutter/material.dart';

import '../../app/app.dart';
import '../../app/app_navigator.dart';
import '../../components/buttons/sq_button.dart';
import '../../components/doc_field_field.dart';
import '../../data/sq_doc_field.dart';
import '../screen.dart';

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
        DocFieldField(emailField),
        DocFieldField(passwordField),
        SQButton("Sign Up", onPressed: () async {
          await App.auth.signUpWithEmailAndPassword(
              email: emailField.value, password: passwordField.value);
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
