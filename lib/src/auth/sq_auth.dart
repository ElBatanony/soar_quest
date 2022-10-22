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

  static Future<void> init({
    SQAuthManager? authManager,
    List<SQField<dynamic>>? userDocFields,
  }) async {
    SQAuth.userDocFields = userDocFields ??
        [
          SQStringField("Full Name", show: isSignedIn),
          SQVirtualField(
              field: SQStringField("User ID"),
              valueBuilder: (doc) => SQAuth.user.userId),
          SQVirtualField(
              field: SQStringField("Email"),
              show: isSignedIn,
              valueBuilder: (doc) => (SQAuth.user as SignedInUser).email),
          SQVirtualField(
              field: SQStringField("Display Name"),
              show: isSignedIn,
              valueBuilder: (doc) => (SQAuth.user as SignedInUser).displayName),
        ];
    SQAuth.auth = authManager ?? FirebaseAuthManager();
    usersCollection = FirestoreCollection(
        id: "Users",
        fields: SQAuth.userDocFields,
        singleDocName: "Profile Info",
        deletes: false,
        actions: [
          CustomAction("Sign Out", customExecute: (doc, context) async {
            await SQAuth.auth.signOut();
            ScreenState.of(context).refreshScreen();
          }),
          // TODO: add condition for showing sign in
          GoScreenAction("Sign In",
              screen: (doc) => SQAuth.auth.signInScreen(forceSignIn: true))
        ]);
    await auth.init();
  }
}
