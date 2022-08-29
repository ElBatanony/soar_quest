import 'package:flutter/material.dart';

import '../app/app.dart';
import '../screens/screen.dart';
import 'buttons/sq_button.dart';

class SignedInContent extends StatefulWidget {
  final Widget child;
  final Screen? redirectScreen;
  final Function? refreshUp;

  const SignedInContent({
    required this.child,
    this.redirectScreen,
    this.refreshUp,
    super.key,
  });

  @override
  State<SignedInContent> createState() => _SignedInContentState();
}

class _SignedInContentState extends State<SignedInContent> {
  bool isHidden = true;

  @override
  void initState() {
    App.auth.authStateChanges().listen((userData) {
      if (userData != null) {
        setState(() {
          isHidden = userData.isAnonymous;
        });
        if (widget.refreshUp != null) widget.refreshUp!();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isHidden
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Sign in to view this content"),
              SQButton("Sign In",
                  onPressed: () => App.auth.goToSignIn(context,
                      redirectScreen: widget.redirectScreen))
            ],
          )
        : widget.child;
  }
}
