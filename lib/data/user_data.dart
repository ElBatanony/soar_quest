import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../app/app.dart';
import '../data.dart';

class UserData {
  String userId;
  bool isAnonymous;

  UserData({required this.userId, required this.isAnonymous});

  userDataPath() {
    return "${App.instance.getAppPath()}users/$userId/data/";
  }
}

List<SQDocField> userDocFields = [
  SQStringField("City"),
  SQTimestampField("Birthdate"),
  SQBoolField("Public Profile"),
];

List<SQDocField> publicProfileFields = [
  SQStringField("Username"),
  SQStringField("City"),
  SQTimestampField("Birthdate"),
];

late SQCollection userCollection;
late SQDoc userDoc;

abstract class SignedInUser extends UserData {
  SignedInUser({required super.userId, required super.isAnonymous});

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
        );

  refreshUser() {
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
