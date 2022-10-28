import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/form_screen.dart';
import '../ui/snackbar.dart';
import 'sq_auth.dart';
import '../db/fields/sq_string_field.dart';
import '../ui/sq_button.dart';

class SQSignUpScreen extends FormScreen {
  final bool forceSignIn;

  SQSignUpScreen(
    super.doc, {
    super.title = "Sign Up",
    this.forceSignIn = false,
  });

  @override
  State<SQSignUpScreen> createState() => _SQSignUpScreenState();
}

class _SQSignUpScreenState extends FormScreenState<SQSignUpScreen> {
  final emailField = SQStringField("Email", value: "test@email.com");
  final passwordField = SQStringField("Password", value: "testtest");

  @override
  void initState() {
    if (widget.forceSignIn == false && SQAuth.user.isAnonymous == false) {
      exitScreen();
    }
    super.initState();
  }

  Future<void> signUp() async {
    await SQAuth.auth
        .signUpWithEmailAndPassword(
            email: emailField.value ?? "", password: passwordField.value ?? "")
        .catchError((dynamic err) {
      showSnackBar((err as FirebaseAuthException).message ?? "Error signing in",
          context: context);
    });
    if (SQAuth.user.isAnonymous) {
      print("Did not sign in");
      showSnackBar("Error signing in", context: context);
    } else {
      print("Signed in");
      exitScreen();
    }
  }

  @override
  Widget? bottomNavBar(BuildContext context) => null;

  @override
  Widget screenBody(BuildContext context) {
    return Column(
      children: [
        super.screenBody(context),
        SQButton("Sign Up", onPressed: signUp),
      ],
    );
  }
}
