import 'package:flutter/material.dart';

import '../auth/sq_auth.dart';
import '../db/sq_field.dart';
import '../db/fields/show_field_dialog.dart';
import '../db/fields/sq_string_field.dart';
import '../features/app_settings.dart';
import '../ui/signed_in_content.dart';
import '../ui/sq_button.dart';
import 'screen.dart';
import 'form_screen.dart';

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
    await SQAuth.auth.signOut();
    refreshScreen();
  }

  Future goToSignIn() {
    return SQAuth.auth.signInScreen(forceSignIn: true).go(context);
  }

  updateUserField(SQField field, Function updateFunction) async {
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
          Text("User ID: ${SQAuth.user.userId}"),
          Text("User Anonymous: ${SQAuth.user.isAnonymous}"),
          SignedInContent(
              builder: (BuildContext context, SignedInUser user) {
                return Column(
                  children: [
                    Text("Username: ${user.displayName}"),
                    Text("Email: ${user.email ?? "No-email"}"),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: SQAuth.userDoc.fields
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
                            await FormScreen(SQAuth.userDoc).go(context);
                            refreshScreen();
                          },
                        ),
                        if (AppSettings.settingsDoc != null)
                          SQButton("Settings",
                              onPressed: () =>
                                  AppSettings.settingsScreen().go(context)),
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
