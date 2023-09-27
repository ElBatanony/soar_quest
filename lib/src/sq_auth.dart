import 'dart:async';

import 'package:flutter/material.dart';

import 'data/collections/local_collection.dart';
import 'fields/string_field.dart';
import 'screens/screen.dart';

enum AuthMethod { email, phone }

class SQAuth {
  static SQUser? get user => offline ? OfflineUser() : null;

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
    userDocFields.insert(0, SQStringField('Email')..editable = false);
    if (offline) {
      usersCollection = LocalCollection(
          id: 'Users', fields: userDocFields, updates: SQUpdates.readOnly());
    } else {
      usersCollection = LocalCollection(
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

class OfflineUser extends SQUser {
  @override
  String get userId => 'Offline User';
  @override
  String get email => 'Offline Email';
}

class SQProfileScreen extends Screen {
  SQProfileScreen({String title = 'Profile', super.icon = Icons.account_circle})
      : super(title);

  @override
  screenBody() => const Center(child: Text('Profile Screen'));

  @override
  void refresh() {
    unawaited(SQAuth.initUserDoc());
    super.refresh();
  }
}
