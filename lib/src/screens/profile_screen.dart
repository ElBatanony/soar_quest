import 'package:flutter/material.dart';

import '../auth/sq_auth.dart';
import 'doc_screen.dart';

class SQProfileScreen extends DocScreen {
  SQProfileScreen({
    super.title = "Profile",
    super.icon = Icons.account_circle,
    super.key,
  }) : super(SQAuth.userDoc);

  @override
  State<SQProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends DocScreenState<SQProfileScreen> {
  @override
  void initState() {
    super.initState();
    doc.getField("New Username")?.value = SQAuth.signedInUser.username;
    doc.getField("New Email")?.value = SQAuth.signedInUser.email;
    doc.getField("New Password")?.value = "";
  }
}
