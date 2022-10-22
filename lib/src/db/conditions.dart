import 'package:flutter/material.dart';

import '../auth/sq_auth.dart';
import '../screens/form_screen.dart';
import '../screens/screen.dart';
import '../ui/signed_in_content.dart';
import 'sq_doc.dart';

typedef DocCond = bool Function(SQDoc doc, BuildContext context);

bool trueCond(SQDoc doc, BuildContext context) => true;

DocCond inFormScreen =
    (_, context) => ScreenState.of(context) is FormScreenState;

DocCond isSignedIn =
    (_, context) => SQAuth.user is SignedInUser && !SQAuth.user.isAnonymous;
