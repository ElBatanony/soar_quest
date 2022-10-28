import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/form_screen.dart';
import 'sq_auth.dart';
import '../ui/sq_button.dart';
import '../ui/snackbar.dart';

class SignInScreen extends FormScreen {
  final bool forceSignIn;

  SignInScreen(super.doc, {super.title = "Sign In", this.forceSignIn = false});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends FormScreenState<SignInScreen> {
  @override
  void initState() {
    if (widget.forceSignIn == false && SQAuth.user.isAnonymous == false) {
      exitScreen();
    }
    super.initState();
  }

  void signIn() async {
    await SQAuth.auth
        .signInWithEmailAndPassword(
            email: doc.value<String>("Email")!,
            password: doc.value<String>("Password")!)
        .catchError((dynamic err) {
      showSnackBar((err as FirebaseAuthException).message ?? "Error signing in",
          context: context);
    });

    if (SQAuth.user.isAnonymous == false) {
      print("Signed in");
      exitScreen();
    }
  }

  // TODO: hide bottomNavBar in sign in screen

  @override
  Widget screenBody(BuildContext context) {
    return Column(
      children: [
        super.screenBody(context),
        Row(
          children: [
            SQButton("Sign In", onPressed: signIn),
            SQButton(
              "Sign Up",
              onPressed: () =>
                  SQAuth.auth.signUpScreen().go(context, replace: true),
            )
          ],
        ),
      ],
    );
  }
}
