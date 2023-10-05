import 'package:flutter/material.dart';

import '../fields/ref_field.dart';
import '../screens/doc_screen.dart';
import 'auth.dart';

class FirebaseProfileScreen extends DocScreen {
  FirebaseProfileScreen(
      {String title = 'Profile', super.icon = Icons.account_circle})
      : super(SQFirebaseAuth.userDoc!, title: title);
}

// Fields

class SQUserRefField extends SQRefField {
  SQUserRefField(super.name)
      : super(collection: SQFirebaseAuth.usersCollection);
}

class SQEditedByField extends SQUserRefField {
  SQEditedByField(super.name) {
    editable = false;
  }
}
