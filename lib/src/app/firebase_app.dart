import 'package:firebase_core/firebase_core.dart';
export 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

Future<FirebaseApp> initializeFirebaseApp(FirebaseOptions options) {
  return Firebase.initializeApp(options: options);
}
