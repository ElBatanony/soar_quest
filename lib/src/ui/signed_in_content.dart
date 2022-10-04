import 'dart:async';

import 'package:flutter/material.dart';

import '../auth/user_data.dart';
import '../app/app.dart';
import '../screens/screen_navigation.dart';
import '../screens/screen.dart';
import 'sq_button.dart';

export '../auth/user_data.dart';

typedef SignedInContentBuilder = Widget Function(
    BuildContext context, SignedInUser user);

class SignedInContent extends StatefulWidget {
  final Screen? redirectScreen; // TODO: remove redirectScreen for now
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

  late StreamSubscription listener;

  @override
  void initState() {
    listener = App.auth.authStateChanges().listen((userData) {
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
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isHidden
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Sign in to view this content"),
              SQButton("Sign In",
                  onPressed: () =>
                      goToScreen(App.auth.signInScreen(), context: context))
            ],
          )
        : widget.builder(context, App.auth.user as SignedInUser);
  }
}