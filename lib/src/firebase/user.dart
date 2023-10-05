import 'package:flutter/material.dart';

import '../screens/doc_screen.dart';
import 'auth.dart';

class FirebaseProfileScreen extends DocScreen {
  FirebaseProfileScreen(
      {String title = 'Profile', super.icon = Icons.account_circle})
      : super(SQFirebaseAuth.userDoc!, title: title);
}
