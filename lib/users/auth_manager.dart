import 'package:firebase_auth/firebase_auth.dart';

class AuthManager {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static bool isSignedIn = _auth.currentUser != null;

  static init() {
    //_logAuthChanges();
  }

  static Stream<Map<String, dynamic>> get authChanges =>
      _auth.authStateChanges().map((User? user) => {"signedIn": user != null});

  static signInAnonymously() async {
    try {
      // final userCredential = await FirebaseAuth.instance.signInAnonymously();
      await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
    return;
  }

  static signOut() {
    return _auth.signOut();
  }

  // ignore: unused_element
  static _logAuthChanges() {
    authChanges.listen((event) {
      print(event.toString());
      if (event["signedIn"] == true)
        print("User is logged in");
      else
        print("User is logged out");
    });
  }
}
