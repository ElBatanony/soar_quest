import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';

Future<FirebaseApp> initializeFirebaseApp() {
  return Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
