import '../db/fields/sq_string_field.dart';
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
    SQAuth.userDocFields = userDocFields ?? [SQStringField("Full Name")];
    SQAuth.auth = authManager ?? FirebaseAuthManager();
    usersCollection = FirestoreCollection(
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
