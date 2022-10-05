import 'user_data.dart';
import '../screens/screen.dart';

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
