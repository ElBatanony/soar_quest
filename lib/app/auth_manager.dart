import 'package:firebase_auth/firebase_auth.dart';

import '../data/user_data.dart';
import '../screens.dart';

abstract class SQAuthManager {
  Future init();

  late UserData user;

  updateUserData();

  Stream<UserData?> authStateChanges();

  Screen signInScreen({bool forceSignIn = false});
  Screen signUpScreen();

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
    return _auth.authStateChanges().map((user) {
      if (user == null) return null;
      return FirebaseSignedInUser(user);
    });
  }

  @override
  Screen signInScreen({bool forceSignIn = false}) {
    return SignInScreen(forceSignIn: forceSignIn);
  }

  @override
  Screen signUpScreen() {
    return SQSignUpScreen();
  }

  @override
  Future signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    List<String> methods = await _auth.fetchSignInMethodsForEmail(email);

    if (methods.isEmpty) {
      print("Should sign up");
    } else {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    }

    await updateUserData();
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
