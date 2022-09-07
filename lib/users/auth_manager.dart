import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../data.dart';
import '../data/firestore.dart';
import '../app/app_navigator.dart';
import '../screens/auth/sign_in_screen.dart';

abstract class SQAuthManager {
  Future init();

  late UserData user;

  updateUserData() {
    String userId = user.userId;
    userCollection = FirestoreCollection(
      id: "users",
      fields: userDocFields,
      singleDocName: "Profile Info",
      canDeleteDoc: false,
    );
    userDoc = SQDoc(userId, collection: userCollection);
  }

  Stream<UserData?> authStateChanges();

  goToSignIn(BuildContext context, {bool forceSignIn = false});

  Future signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future signOut();

  Future signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
}

class FirebaseAuthManager extends SQAuthManager {
  static late final FirebaseAuth _auth;

  @override
  updateUserData() {
    final firebaseUser = _auth.currentUser!;
    user = FirebaseSignedInUser(firebaseUser);
    return super.updateUserData();
  }

  @override
  init() async {
    _auth = FirebaseAuth.instance;
    if (_auth.currentUser == null) await _auth.signInAnonymously();
    updateUserData();

    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.uid);
      }
    });
  }

  @override
  Stream<UserData?> authStateChanges() {
    return _auth.authStateChanges().map((user) => user == null
        ? UserData(userId: "temp", isAnonymous: true)
        : UserData(userId: user.uid, isAnonymous: user.isAnonymous));
  }

  @override
  goToSignIn(BuildContext context, {bool forceSignIn = false}) {
    return goToScreen(SignInScreen(forceSignIn: forceSignIn), context: context);
  }

  @override
  Future signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    List<String> methods = await _auth.fetchSignInMethodsForEmail(email);

    if (methods.isEmpty) {
      // await _auth.createUserWithEmailAndPassword(
      //     email: email, password: password);
      print("Should sign up");
    } else {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    }

  @override
  Future signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await updateUserData();
  }

  @override
  signOut() async {
    await _auth.signOut();
    print("Signed out");
    await _auth.signInAnonymously();
    print("Signed in anonymously");
    updateUserData();
  }
}
