import 'package:firebase_auth/firebase_auth.dart';

import '../db/fields/sq_string_field.dart';
import '../db/in_memory_collection.dart';
import 'sq_auth.dart';
import 'user_data.dart';
import '../screens/screen.dart';
import 'sq_auth_manager.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

class FirebaseAuthManager extends SQAuthManager {
  static late final FirebaseAuth _auth;

  late InMemoryCollection fakeSignInCollection;

  @override
  Future<void> updateUserData() async {
    final firebaseUser = _auth.currentUser!;
    user = FirebaseSignedInUser(firebaseUser);
    SQAuth.userDoc.getField("Email")!.value = firebaseUser.email;
    SQAuth.userDoc.getField("User ID")!.value = firebaseUser.uid;
    SQAuth.userDoc.getField("Username")!.value = firebaseUser.displayName;
    SQAuth.usersCollection.saveDoc(SQAuth.userDoc);
  }

  @override
  init() async {
    _auth = FirebaseAuth.instance;

    fakeSignInCollection = InMemoryCollection(id: "Sign In", fields: [
      SQStringField("Email", value: "test@email.com"),
      SQStringField("Password", value: "testtest")
    ]);

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
    return SignInScreen(fakeSignInCollection.newDoc(),
        forceSignIn: forceSignIn);
  }

  @override
  Screen signUpScreen() {
    return SQSignUpScreen(fakeSignInCollection.newDoc());
  }

  @override
  Future<void> signInWithEmailAndPassword({
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
  Future<void> signUpWithEmailAndPassword({
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
