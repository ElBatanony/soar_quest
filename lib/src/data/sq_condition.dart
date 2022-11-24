import '../sq_auth.dart';
import '../screens/form_screen.dart';
import 'fields/types/sq_ref.dart';
import 'sq_collection.dart';

class DocCond {
  final bool Function(SQDoc doc, ScreenState screenState) condition;

  const DocCond(this.condition);

  bool check(SQDoc doc, ScreenState screenState) => condition(doc, screenState);

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
    DocCond((_, screenState) => screenState is FormScreenState);

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
      : super(fieldName,
            userRef ?? (SQAuth.isSignedIn ? SQAuth.userDoc!.ref : null));
}