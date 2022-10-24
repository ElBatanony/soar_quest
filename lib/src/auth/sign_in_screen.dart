import 'package:flutter/material.dart';

import '../screens/form_screen.dart';
import 'sq_auth.dart';
import '../ui/sq_button.dart';

class SignInScreen extends FormScreen {
  final bool forceSignIn;

  SignInScreen(
    super.doc, {
    String title = "Sign In",
    this.forceSignIn = false,
  }) : super(title: title);

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
    await SQAuth.auth.signInWithEmailAndPassword(
        email: doc.value<String>("Email")!,
        password: doc.value<String>("Password")!);

    if (SQAuth.user.isAnonymous) {
      print("Did not sign in");
    } else {
      print("Signed in");
      exitScreen();
    }
  }

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
