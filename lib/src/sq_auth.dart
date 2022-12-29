import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'data/collections/firestore_collection.dart';
import 'data/collections/local_collection.dart';
import 'data/fields/string_field.dart';

import 'data/sq_action.dart';
import 'screens/screen.dart';

enum AuthMethod { email, phone }

class SQAuth {
  static SQUser? get user => offline
      ? OfflineUser()
      : FirebaseAuth.instance.currentUser == null
          ? null
          : FirebaseUser();

  static bool get isSignedIn => user != null;

  static late SQCollection usersCollection;
  static late SQDoc? userDoc;

  static late List<AuthMethod> methods;

  static bool offline = false;

  static Future<void> initUserDoc() async {
    if (isSignedIn) {
      userDoc = usersCollection.getDoc(user!.userId);
      if (userDoc == null) {
        userDoc = usersCollection
            .newDoc(id: user!.userId, source: {'Email': SQAuth.user!.email});
        await usersCollection.saveDoc(userDoc!);
      } else {
        if (userDoc!.getValue<String>('Email') != SQAuth.user!.email) {
          userDoc!.setValue('Email', SQAuth.user!.email);
          await usersCollection.saveDoc(userDoc!);
        }
      }
    } else {
      userDoc = null;
    }
  }

  static Future<void> init({
    List<SQField<dynamic>>? userDocFields,
    List<AuthMethod>? methods,
  }) async {
    SQAuth.methods = methods ?? [AuthMethod.email];
    userDocFields ??= [];
    userDocFields.insert(0, SQStringField('Email', editable: false));
    if (offline) {
      usersCollection = LocalCollection(
          id: 'Users', fields: userDocFields, updates: SQUpdates.readOnly());
    } else {
      usersCollection = FirestoreCollection(
          id: 'Users', fields: userDocFields, updates: SQUpdates.readOnly());
    }
    await usersCollection.loadCollection();
    await initUserDoc();
  }
}

abstract class SQUser {
  String get userId;
  String get email;
}

class FirebaseUser extends SQUser {
  User get firebaseUser => FirebaseAuth.instance.currentUser!;

  @override
  String get userId => firebaseUser.uid;
  @override
  String get email => firebaseUser.email!;
}

class OfflineUser extends SQUser {
  @override
  String get userId => 'Offline User';
  @override
  String get email => 'Offline Email';
}

class SQProfileScreen extends Screen {
  SQProfileScreen(
      {super.title = 'Profile', super.icon = Icons.account_circle}) {
    providers = [
      if (SQAuth.methods.contains(AuthMethod.email)) EmailAuthProvider(),
      if (SQAuth.methods.contains(AuthMethod.phone)) PhoneAuthProvider(),
    ];
  }

  late final List<AuthProvider> providers;

  @override
  State<SQProfileScreen> createState() => _SQProfileScreenState();

  @override
  Widget screenBody(ScreenState screenState) {
    if (SQAuth.offline) {
      return const Center(child: Text('Profile Screen'));
    }

    if (SQAuth.user == null) {
      return SignInScreen(
        providers: providers,
        actions: [
          AuthStateChangeAction<SignedIn>((bcontext, state) => refresh()),
        ],
      );
    }
    return ProfileScreen(
      actions: [
        AuthStateChangeAction<SignedIn>((bcontext, state) => refresh()),
        SignedOutAction((bcontext) => refresh()),
      ],
      providers: providers,
      children: [
        if (SQAuth.userDoc != null)
          GoEditAction(name: 'Edit Profile', show: isSignedIn)
              .button(SQAuth.userDoc!, screenState: screenState),
      ],
    );
  }
}

class _SQProfileScreenState extends ScreenState<SQProfileScreen> {
  @override
  void refresh() {
    unawaited(SQAuth.initUserDoc());
    super.refresh();
  }
}
