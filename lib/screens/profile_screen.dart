import 'package:flutter/material.dart';
import 'package:soar_quest/components/buttons/sq_button.dart';

import '../app/app.dart';
import '../components/signed_in_content.dart';
import '../data.dart';
import 'doc_screen.dart';

class ProfileScreen extends DocScreen {
  ProfileScreen(String title, {super.key})
      : super(
          title,
          userDoc,
          refreshCollectionScreen: () {},
        );

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends DocScreenState<ProfileScreen> {
  @override
  Widget screenBody(BuildContext context) {
    return Column(
      children: [
        Text("User ID: ${App.auth.user.userId}"),
        Text("User Anonymous: ${App.auth.user.isAnonymous}"),
        SignedInContent(child: Text("Important stuff for non-anonymous users")),
        SignedInContent(
            child: SQButton("Sign out", onPressed: () async {
              await App.auth.signOut();
              setState(() {});
            }),
            refreshUp: () {
              setState(() {});
            }),
        super.screenBody(context),
      ],
    );
  }
}
