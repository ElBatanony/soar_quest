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
  static late SQCollection
      usersCollection; // TODO: make fetch only current user
  static UserData get user => auth.user;
  static SQDoc get userDoc => user.userDoc;
  static List<SQField<dynamic>> userDocFields = [];
  static SignedInUser get signedInUser => user as SignedInUser;

  static Future<void> init({
    SQAuthManager? authManager,
    List<SQField<dynamic>>? userDocFields,
  }) async {
    SQAuth.userDocFields = userDocFields ??
        [
          SQVirtualField(
              field: SQStringField("Email"),
              show: isSignedIn,
              valueBuilder: (doc) => SQAuth.signedInUser.email),
          SQVirtualField(
              field: SQStringField("User ID"),
              valueBuilder: (doc) => SQAuth.user.userId),
          SQVirtualField(
              field: SQStringField("Username"),
              show: isSignedIn,
              valueBuilder: (doc) => SQAuth.signedInUser.displayName),
          SQStringField("New Username", show: inFormScreen),
        ];
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
              show: isSignedIn.not(),
              screen: (doc) => SQAuth.auth.signInScreen(forceSignIn: true)),
          GoEditAction(
              name: "Edit Profile",
              onExecute: (doc) async {
                String newUsername = doc.value("New Username") ?? "";
                if (newUsername == SQAuth.signedInUser.displayName) return;
                print("Updating username");
                await SQAuth.signedInUser.updateDisplayName(newUsername);
              })
        ]);
    usersCollection.actions.removeWhere((action) => action.name == "Edit");
    await auth.init();
  }
}
