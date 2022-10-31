import 'package:flutter/material.dart';

import '../auth/sq_auth.dart';
import '../screens/form_screen.dart';
import '../screens/screen.dart';
import 'fields/sq_user_ref_field.dart';
import 'fields/types/sq_ref.dart';
import 'sq_collection.dart';

class DocCond {
  final bool Function(SQDoc, BuildContext) condition;

  const DocCond(this.condition);

  bool check(SQDoc doc, BuildContext context) => condition(doc, context);

  DocCond get not => DocCond((doc, context) => !condition(doc, context));

  DocCond operator &(DocCond other) {
    return DocCond((doc, context) =>
        condition(doc, context) && other.condition(doc, context));
  }

  DocCond operator |(DocCond other) {
    return DocCond((doc, context) =>
        condition(doc, context) || other.condition(doc, context));
  }
}

bool _alwaysTrue(doc, context) => true;
bool _alwaysFalse(doc, context) => false;

const trueCond = DocCond(_alwaysTrue);
const falseCond = DocCond(_alwaysFalse);

DocCond inFormScreen =
    DocCond((_, context) => ScreenState.of(context) is FormScreenState);

DocCond isSignedIn = DocCond((doc, context) => SQAuth.isSignedIn);

class DocValueCond<T> extends DocCond {
  DocValueCond(String fieldName, T expectedValue)
      : super((doc, context) => doc.value<T>(fieldName) == expectedValue);
}

class CollectionCond extends DocCond {
  bool Function(SQCollection) collectionCondition;

  CollectionCond(this.collectionCondition)
      : super((doc, context) => collectionCondition(doc.collection));
}

class DocUserCond extends DocValueCond<SQRef?> {
  DocUserCond(String fieldName, {SQRef? userRef})
      : super(fieldName, userRef ?? SQUserRefField.currentUserRef);
}
