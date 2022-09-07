import 'package:flutter/material.dart';
import 'package:soar_quest/components/buttons/sq_button.dart';

import '../app/app.dart';
import '../app/app_navigator.dart';
import '../components/doc_field_field.dart';
import '../components/signed_in_content.dart';
import '../data.dart';
import 'screen.dart';

class ProfileScreen extends Screen {
  const ProfileScreen(super.title, {super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ScreenState<ProfileScreen> {
  signOut() async {
    await App.auth.signOut();
    refreshScreen();
  }

  Future goToSignIn() {
    return goToScreen(App.auth.signInScreen(forceSignIn: true),
        context: context);
  }

  updateUserField(SQDocField field, Function updateFunction) async {
    dynamic newValue = await showFieldDialog(context: context, field: field);
    if (newValue != null) {
      await updateFunction(newValue);
      refreshScreen();
    }
  }

  updateUsername(SignedInUser user) async {
    return updateUserField(
        SQStringField("Username", value: user.displayName ?? ""),
        user.updateDisplayName);
  }

  updateEmail(SignedInUser user) async {
    try {
      await updateUserField(
          SQStringField("Email", value: user.email ?? ""), user.updateEmail);
    } catch (e) {
      print(e.toString());
      await goToSignIn();
    }
  }

  updatePassword(SignedInUser user) async {
    try {
      await updateUserField(SQStringField("Password"), user.updatePassword);
    } catch (e) {
      print(e.toString());
      await goToSignIn();
    }
  }

  @override
  Widget screenBody(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text("User ID: ${App.auth.user.userId}"),
          Text("User Anonymous: ${App.auth.user.isAnonymous}"),
          SignedInContent(
              builder: (BuildContext context, SignedInUser user) {
                return Column(
                  children: [
                    Text("Important stuff for non-anonymous users"),
                    Text("Username: ${user.displayName}"),
                    Text("Email: ${user.email ?? "No-email"}"),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        SQButton('Update username',
                            onPressed: () => updateUsername(user)),
                        SQButton('Update email',
                            onPressed: () => updateEmail(user)),
                        SQButton('Update password',
                            onPressed: () => updatePassword(user)),
                      ],
                    ),
                    super.screenBody(context),
                    SQButton("Sign out", onPressed: signOut),
                  ],
                );
              },
              refreshUp: refreshScreen),
        ],
      ),
    );
  }
}
