import 'package:flutter/material.dart';

import '../data/collections/collection_filter.dart';
import '../data/sq_doc.dart';
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

class SQCreatedByField extends SQUserRefField {
  SQCreatedByField(super.name) {
    editable = false;
  }

  @override
  init(doc) {
    super.init(doc);
    if (SQFirebaseAuth.isSignedIn && doc.getValue<SQRef>(name) == null)
      doc.setValue(name, SQFirebaseAuth.userDoc!.ref);
  }
}

// Filters

class UserFilter extends RefFilter {
  UserFilter(String userFieldName, {SQRef? userRef})
      : super(
          userFieldName,
          userRef ??
              (SQFirebaseAuth.isSignedIn ? SQFirebaseAuth.userDoc!.ref : null),
        );
}

// DocConditions

DocCond isSignedIn = DocCond((doc, context) => SQFirebaseAuth.isSignedIn);

class DocUserCond extends DocValueCond<SQRef?> {
  DocUserCond(String fieldName, {SQRef? userRef})
      : super(
            fieldName,
            userRef ??
                (SQFirebaseAuth.isSignedIn
                    ? SQFirebaseAuth.userDoc!.ref
                    : null));
}
