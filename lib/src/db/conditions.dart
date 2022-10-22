import 'package:flutter/material.dart';

import '../auth/sq_auth.dart';
import '../screens/form_screen.dart';
import '../screens/screen.dart';
import '../ui/signed_in_content.dart';
import 'sq_doc.dart';

typedef DocCondition = bool Function(SQDoc doc);
typedef DocContextCondition = bool Function(SQDoc doc, BuildContext context);

bool trueCond(SQDoc doc) => true;
bool falseCond(SQDoc doc) => false;

bool trueContextCond(SQDoc doc, BuildContext context) => true;

DocContextCondition inFormScreen =
    (_, context) => ScreenState.of(context) is FormScreenState;

DocContextCondition isSignedIn =
    (_, context) => SQAuth.user is SignedInUser && !SQAuth.user.isAnonymous;
