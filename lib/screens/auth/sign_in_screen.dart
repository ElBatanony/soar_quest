import 'package:flutter/material.dart';

import '../../app/app.dart';
import '../../app/app_navigator.dart';
import '../../components/buttons/sq_button.dart';
import '../../components/doc_field_field.dart';
import '../../data/sq_doc_field.dart';
import '../screen.dart';

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
        Text("hello. i am sign in"),
        DocFieldField(emailField),
        DocFieldField(passwordField),
        SQButton("Sign In", onPressed: () async {
          await App.auth.signInWithEmailAndPassword(
              email: emailField.value, password: passwordField.value);
          if (App.auth.user.isAnonymous) {
            print("Did not sign in");
          } else {
            print("Signed in");
            redirect();
          }
        })
      ],
    );
  }
}
