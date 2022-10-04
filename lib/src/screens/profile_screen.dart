import 'package:flutter/material.dart';

import '../../app.dart';
import '../db/sq_doc_field.dart';
import '../db/fields/show_field_dialog.dart';
import '../db/fields/sq_string_field.dart';
import '../ui/signed_in_content.dart';
import '../ui/sq_button.dart';
import 'screen.dart';
import 'form_screens/doc_edit_screen.dart';

class ProfileScreen extends Screen {
  const ProfileScreen({
    String title = "Profile",
    super.prebody,
    super.postbody,
    super.key,
  }) : super(title, icon: Icons.account_circle);

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
                    Text("Username: ${user.displayName}"),
                    Text("Email: ${user.email ?? "No-email"}"),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: App.auth.user.userDoc.fields
                          .map((field) => Text(field.toString()))
                          .toList(),
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        SQButton('Update username',
                            onPressed: () => updateUsername(user)),
                        SQButton('Update email',
                            onPressed: () => updateEmail(user)),
                        SQButton('Update password',
                            onPressed: () => updatePassword(user)),
                        SQButton(
                          "Edit Profile Info",
                          onPressed: () async {
                            await goToScreen(
                                docEditScreen(
                                  App.auth.user.userDoc,
                                ),
                                context: context);
                            refreshScreen();
                          },
                        ),
                        settingsScreen().button(context, label: "Settings"),
                        SQButton("Sign out", onPressed: signOut),
                      ],
                    ),
                  ],
                );
              },
              refreshUp: refreshScreen),
        ],
      ),
    );
  }
}

Screen settingsScreen() {
  return docEditScreen(App.instance.settings.settingsDoc);
}
