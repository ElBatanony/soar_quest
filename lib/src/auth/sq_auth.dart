import '../db/conditions.dart';
import '../db/fields/sq_string_field.dart';
import '../db/fields/sq_virtual_field.dart';
import '../db/firestore_collection.dart';
import '../db/sq_action.dart';
import '../db/sq_collection.dart';

import '../screens/screen.dart';
import 'sq_auth_manager.dart';
import 'firebase_auth_manager.dart';
import 'user_data.dart';

class SQAuth {
  static late SQAuthManager auth;
  static late SQCollection usersCollection;
  static UserData get user => auth.user;
  static SQDoc get userDoc => user.userDoc;
  static List<SQField<dynamic>> userDocFields = [];
  static SignedInUser get signedInUser => user as SignedInUser;

  static Future<void> init({
    SQAuthManager? authManager,
    List<SQField<dynamic>>? userDocFields,
  }) async {
    SQAuth.userDocFields = userDocFields ?? [];
    SQAuth.userDocFields.addAll([
      SQVirtualField(
          field: SQStringField("Email"),
          show: isSignedIn,
          valueBuilder: (doc) => SQAuth.signedInUser.email),
      SQVirtualField(
          field: SQStringField("User ID"),
          show: isSignedIn,
          valueBuilder: (doc) => SQAuth.user.userId),
      SQVirtualField(
          field: SQStringField("Username"),
          show: isSignedIn,
          valueBuilder: (doc) => SQAuth.signedInUser.username),
      SQStringField("New Username", show: inFormScreen),
      SQStringField("New Email", show: inFormScreen),
      SQStringField("New Password", show: inFormScreen),
    ]);
    SQAuth.auth = authManager ?? FirebaseAuthManager();
    usersCollection = FirestoreCollection(
        id: "Users",
        fields: SQAuth.userDocFields,
        singleDocName: "Profile Info",
        deletes: false,
        actions: [
          CustomAction(
            "Sign Out",
            show: isSignedIn,
            customExecute: (doc, context) async {
              await SQAuth.auth.signOut();
              ScreenState.of(context).refreshScreen();
            },
          ),
          GoScreenAction("Sign In",
              show: isSignedIn.not,
              screen: (doc) => SQAuth.auth.signInScreen(forceSignIn: true)),
          GoEditAction(
              name: "Edit Profile",
              show: isSignedIn,
              onExecute: (doc, context) async {
                String newUsername = doc.value("New Username") ?? "";
                String newEmail = doc.value("New Email") ?? "";
                String newPassword = doc.value("New Password") ?? "";
                if (newUsername != SQAuth.signedInUser.username &&
                    newUsername.isNotEmpty)
                  await SQAuth.signedInUser.updateDisplayName(newUsername);
                if (newEmail != SQAuth.signedInUser.email &&
                    newEmail.isNotEmpty)
                  await SQAuth.signedInUser.updateEmail(newEmail);
                if (newPassword.isNotEmpty)
                  await SQAuth.signedInUser.updatePassword(newPassword);
              })
        ]);
    usersCollection.actions.removeWhere((action) => action.name == "Edit");
    await usersCollection.loadCollection();
    await auth.init();
  }
}
