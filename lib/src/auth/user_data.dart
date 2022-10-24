import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'sq_auth.dart';
import '../db/sq_doc.dart';

abstract class UserData {
  String userId;
  bool isAnonymous;

  SQDoc get userDoc =>
      SQAuth.usersCollection.getDoc(userId) ??
      SQAuth.usersCollection.newDoc(id: userId);

  List<SQField<dynamic>> docFields;

  UserData({
    required this.userId,
    required this.isAnonymous,
    required this.docFields,
  });
}

abstract class SignedInUser extends UserData {
  SignedInUser(
      {required super.userId,
      required super.isAnonymous,
      required super.docFields});

  String? get email;
  String? get displayName;

  Future<void> updateEmail(String newEmail);

  Future<void> updatePassword(String newPassword);

  Future<void> updateDisplayName(String displayName);
}

class FirebaseSignedInUser extends SignedInUser {
  firebase_auth.User firebaseUser;

  FirebaseSignedInUser(this.firebaseUser)
      : super(
          userId: firebaseUser.uid,
          isAnonymous: firebaseUser.isAnonymous,
          docFields: SQAuth.userDocFields,
        );

  void refreshUser() {
    firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser!;
  }

  @override
  String? get email => firebaseUser.email;

  @override
  String? get displayName => firebaseUser.displayName;

  @override
  Future<void> updateEmail(String newEmail) async {
    await firebaseUser.updateEmail(newEmail);
    refreshUser();
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    await firebaseUser.updatePassword(newPassword);
    refreshUser();
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    await firebaseUser.updateDisplayName(displayName);
    refreshUser();
  }
}
