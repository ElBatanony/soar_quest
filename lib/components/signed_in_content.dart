import 'package:flutter/material.dart';

import '../app/app.dart';
import '../data.dart';
import '../screens/screen.dart';
import 'buttons/sq_button.dart';

typedef SignedInContentBuilder = Widget Function(
    BuildContext context, SignedInUser user);

class SignedInContent extends StatefulWidget {
  final Screen? redirectScreen;
  final Function? refreshUp;
  final SignedInContentBuilder builder;

  const SignedInContent({
    required this.builder,
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
        : widget.builder(context, App.auth.user as SignedInUser);
  }
}
