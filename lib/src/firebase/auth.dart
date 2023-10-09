import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../soar_quest.dart';
import 'firestore_collection.dart';

export 'user.dart';

class SQFirebaseAuth {
  static User? get user => FirebaseAuth.instance.currentUser;
  static bool get isSignedIn => user != null;

  static late SQCollection usersCollection;
  static SQDoc? userDoc;

  static Future<void> init({
    required String generateTokenUrl,
    List<SQField<dynamic>>? userDocFields,
  }) async {
    if (!isSignedIn)
      await SQFirebaseAuth._loginWithCustomToken(generateTokenUrl);

    userDocFields ??= [];
    userDocFields
      ..insert(
          0,
          SQStringField('User ID')
            ..editable = false
            ..show = falseCond)
      ..insert(0, SQStringField('Username')..editable = false);

    usersCollection = FirestoreCollection(
      id: 'Users',
      fields: userDocFields,
      updates: const SQUpdates(adds: false, deletes: false),
    );

    await usersCollection.loadCollection();

    if (isSignedIn) {
      userDoc = usersCollection.getDoc(user!.uid);
      userDoc ??= usersCollection.newDoc(id: user!.uid);
      userDoc!.setValue('Username', MiniApp.user.username ?? MiniApp.user.id);
      userDoc!.setValue('User ID', MiniApp.user.id);
      unawaited(SQApp.analytics?.setUserId(user!.uid));
      await usersCollection.saveDoc(userDoc!);
    } else {
      userDoc = null;
    }
  }

  static Future<void> _loginWithCustomToken(String generateTokenUrl) async {
    final response = await http.post(
      Uri.parse(generateTokenUrl),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'initData': MiniApp.initData.rawInitdata}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final customToken = data['customToken'] as String;
      await FirebaseAuth.instance
          .signInWithCustomToken(customToken)
          .then((value) => {debugPrint('User signed in with custom token!')});
    } else {
      throw Exception('Failed to sign in with custom token!');
    }
  }
}
