import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'db/fields/sq_string_field.dart';
import 'db/firestore_collection.dart';
import 'db/sq_collection.dart';

import 'db/sq_action.dart';
import 'screens/screen.dart';

class SQAuth {
  static SQUser? get user =>
      FirebaseAuth.instance.currentUser == null ? null : SQUser();

  static bool get isSignedIn => user != null;

  static late SQCollection usersCollection;
  static late SQDoc? userDoc;

  static Future<void> init({
    List<SQField<dynamic>>? userDocFields,
  }) async {
    userDocFields = userDocFields ?? [];
    userDocFields.insert(0, SQStringField("Email", editable: false));
    usersCollection =
        FirestoreCollection(id: "Users", fields: userDocFields, readOnly: true);
    await usersCollection.loadCollection();
    if (isSignedIn) {
      userDoc = usersCollection.getDoc(user!.userId);
      if (userDoc == null) {
        userDoc = usersCollection.newDoc(id: user!.userId, initialFields: [
          SQStringField("Email", value: SQAuth.user!.email, editable: false)
        ]);
        await usersCollection.saveDoc(userDoc!);
      } else {
        if (userDoc!.value<String>("Email") != SQAuth.user!.email) {
          userDoc!.getField("Email")!.value = SQAuth.user!.email;
          await usersCollection.saveDoc(userDoc!);
        }
      }
    }
  }
}

class SQUser {
  User get firebaseUser => FirebaseAuth.instance.currentUser!;

  String get userId => firebaseUser.uid;
  String get email => firebaseUser.email!;
}

class SQProfileScreen extends Screen {
  const SQProfileScreen(
      {String title = "Profile", super.icon = Icons.account_circle})
      : super(title);

  @override
  State<SQProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ScreenState<SQProfileScreen> {
  @override
  Widget screenBody(BuildContext context) {
    if (SQAuth.user == null) {
      return SignInScreen(
        providers: [EmailAuthProvider()],
        actions: [
          AuthStateChangeAction<SignedIn>((context, state) {
            refreshScreen();
          }),
        ],
      );
    }
    return ProfileScreen(
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          refreshScreen();
        }),
        SignedOutAction((context) {
          refreshScreen();
        }),
      ],
      children: [
        if (SQAuth.userDoc != null)
          GoEditAction(name: "Edit Profile", show: isSignedIn)
              .button(SQAuth.userDoc!),
      ],
    );
  }
}
