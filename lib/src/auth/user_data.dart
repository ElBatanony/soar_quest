import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'sq_auth.dart';
import '../db/sq_doc.dart';

abstract class UserData {
  String userId;
  bool isAnonymous;

  late SQDoc userDoc;

  List<SQField> docFields;
  List<SQField> publicFields;

  UserData(
      {required this.userId,
      required this.isAnonymous,
      required this.docFields,
      this.publicFields = const []});
}

abstract class SignedInUser extends UserData {
  SignedInUser(
      {required super.userId,
      required super.isAnonymous,
      required super.docFields});

  String? get email;
  String? get displayName;

  Future updateEmail(String newEmail);

  Future updatePassword(String newPassword);

  Future<void> updateDisplayName(String displayName);
}

class FirebaseSignedInUser extends SignedInUser {
  firebase_auth.User firebaseUser;

  FirebaseSignedInUser(this.firebaseUser)
      : super(
          userId: firebaseUser.uid,
          isAnonymous: firebaseUser.isAnonymous,
          docFields: SQAuth.userDocFields,
        ) {
    userDoc = SQDoc(userId, collection: SQAuth.usersCollection);
    SQAuth.usersCollection.ensureInitialized(userDoc);
  }

  void refreshUser() {
    firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser!;
  }

  @override
  String? get email => firebaseUser.email;

  @override
  String? get displayName => firebaseUser.displayName;

  @override
  Future updateEmail(String newEmail) async {
    await firebaseUser.updateEmail(newEmail);
    refreshUser();
  }

  @override
  Future updatePassword(String newPassword) async {
    await firebaseUser.updatePassword(newPassword);
    refreshUser();
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    await firebaseUser.updateDisplayName(displayName);
    refreshUser();
  }
}
