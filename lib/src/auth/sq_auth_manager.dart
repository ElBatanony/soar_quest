import 'user_data.dart';
import '../screens/screen.dart';

abstract class SQAuthManager {
  // TODO: combine with SQAuth
  // TODO: use Firebase Auth UI package

  Future<void> init();

  late UserData user;

  Future<void> updateUserData();

  Stream<UserData?> authStateChanges();

  Screen signInScreen({bool forceSignIn = false});
  Screen signUpScreen();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
}
