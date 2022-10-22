import 'package:flutter/material.dart';

import '../auth/sq_auth.dart';
import '../db/fields/show_field_dialog.dart';
import '../db/fields/sq_string_field.dart';
import '../db/sq_field.dart';
import '../ui/signed_in_content.dart';
import '../ui/sq_button.dart';
import 'doc_screen.dart';

class ProfileScreen extends DocScreen {
  ProfileScreen({
    super.title = "Profile",
    super.icon = Icons.account_circle,
    super.prebody,
    super.postbody,
    super.key,
  }) : super(SQAuth.userDoc);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends DocScreenState<ProfileScreen> {
  Future<void> goToSignIn() {
    return SQAuth.auth.signInScreen(forceSignIn: true).go(context);
  }

  Future<void> updateUserField(
      SQField<dynamic> field, Function updateFunction) async {
    dynamic newValue = await showFieldDialog(context: context, field: field);
    if (newValue != null) {
      await updateFunction(newValue);
      refreshScreen();
    }
  }

  Future<void> updateUsername(SignedInUser user) async {
    return updateUserField(
        SQStringField("Username", value: user.displayName ?? ""),
        user.updateDisplayName);
  }

  Future<void> updateEmail(SignedInUser user) async {
    try {
      await updateUserField(
          SQStringField("Email", value: user.email ?? ""), user.updateEmail);
    } catch (e) {
      print(e.toString());
      await goToSignIn();
    }
  }

  Future<void> updatePassword(SignedInUser user) async {
    try {
      await updateUserField(SQStringField("Password"), user.updatePassword);
    } catch (e) {
      print(e.toString());
      await goToSignIn();
    }
  }

  @override
  Widget screenBody(BuildContext context) {
    return Column(
      children: [
        super.screenBody(context),
        SignedInContent(
            builder: (BuildContext context, SignedInUser user) {
              return Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    // TODO: add username and email as doc fields
                    // NOTE: this is broken for now
                    children: [
                      SQButton('Update username',
                          onPressed: () => updateUsername(user)),
                      SQButton('Update email',
                          onPressed: () => updateEmail(user)),
                      SQButton('Update password',
                          onPressed: () => updatePassword(user))
                    ],
                  ),
                ],
              );
            },
            refreshUp: refreshScreen),
      ],
    );
  }
}
