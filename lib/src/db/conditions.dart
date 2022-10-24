import 'package:flutter/material.dart';

import '../auth/sq_auth.dart';
import '../screens/form_screen.dart';
import '../screens/screen.dart';
import '../ui/signed_in_content.dart';
import 'sq_collection.dart';

class DocCond {
  final bool Function(SQDoc, BuildContext) condition;

  const DocCond(this.condition);

  bool check(SQDoc doc, BuildContext context) => condition(doc, context);

  DocCond not() {
    return DocCond((doc, context) => !condition(doc, context));
  }

  DocCond and(DocCond otherCond) {
    return DocCond((doc, context) =>
        condition(doc, context) && otherCond.condition(doc, context));
  }
}

bool _alwaysTrue(doc, context) => true;
bool _alwaysFalse(doc, context) => false;

const trueCond = DocCond(_alwaysTrue);
const falseCond = DocCond(_alwaysFalse);

DocCond inFormScreen =
    DocCond((_, context) => ScreenState.of(context) is FormScreenState);

DocCond isSignedIn = DocCond(
    (doc, context) => SQAuth.user is SignedInUser && !SQAuth.user.isAnonymous);

class DocValueCond<T> extends DocCond {
  DocValueCond(String fieldName, T expectedValue)
      : super((doc, context) => doc.value<T>(fieldName) == expectedValue);
}

class CollectionCond extends DocCond {
  bool Function(SQCollection) collectionCondition;

  CollectionCond(this.collectionCondition)
      : super((doc, context) => collectionCondition(doc.collection));
}
