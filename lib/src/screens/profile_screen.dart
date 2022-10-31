import 'package:flutter/material.dart';

import '../auth/sq_auth.dart';
import 'doc_screen.dart';

class ProfileScreen extends DocScreen {
  ProfileScreen({
    super.title = "Profile",
    super.icon = Icons.account_circle,
    super.key,
  }) : super(SQAuth.userDoc);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends DocScreenState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    doc.getField("New Username")?.value = SQAuth.signedInUser.username;
    doc.getField("New Email")?.value = SQAuth.signedInUser.email;
    doc.getField("New Password")?.value = "";
  }
}
