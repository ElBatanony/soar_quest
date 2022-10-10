import '../db/fields/sq_string_field.dart';
import '../db/firestore_collection.dart';
import '../db/sq_collection.dart';

import 'sq_auth_manager.dart';
import 'firebase_auth_manager.dart';
import 'user_data.dart';

class SQAuth {
  static late SQAuthManager auth;
  static late SQCollection usersCollection;
  static UserData get user => auth.user;
  static SQDoc get userDoc => user.userDoc;
  static List<SQField> userDocFields = [];

  static Future init({
    SQAuthManager? authManager,
    List<SQField>? userDocFields,
  }) async {
    SQAuth.userDocFields = userDocFields ?? [SQStringField("Full Name")];
    SQAuth.auth = authManager ?? FirebaseAuthManager();
    usersCollection = FirestoreCollection(
      id: "Users",
      fields: SQAuth.userDocFields,
      singleDocName: "Profile Info",
      canDeleteDoc: false,
    );
    await auth.init();
  }
}