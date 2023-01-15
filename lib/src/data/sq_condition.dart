import '../screens/form_screen.dart';
import '../screens/screen.dart';
import '../sq_auth.dart';
import 'sq_collection.dart';
import 'types/sq_ref.dart';

class DocCond {
  const DocCond(this.condition);

  final bool Function(SQDoc doc, Screen screen) condition;

  bool check(SQDoc doc, Screen screen) => condition(doc, screen);

  DocCond get not => DocCond((doc, context) => !condition(doc, context));

  DocCond operator &(DocCond other) => DocCond((doc, context) =>
      condition(doc, context) && other.condition(doc, context));

  DocCond operator |(DocCond other) => DocCond((doc, context) =>
      condition(doc, context) || other.condition(doc, context));
}

bool _alwaysTrue(doc, context) => true;
bool _alwaysFalse(doc, context) => false;

const trueCond = DocCond(_alwaysTrue);
const falseCond = DocCond(_alwaysFalse);

DocCond inFormScreen = DocCond((_, screen) => screen is FormScreen);

DocCond isSignedIn = DocCond((doc, context) => SQAuth.isSignedIn);

class DocValueCond<T> extends DocCond {
  DocValueCond(String fieldName, T expectedValue)
      : super((doc, context) => doc.getValue<T>(fieldName) == expectedValue);
}

class CollectionCond extends DocCond {
  CollectionCond(this.collectionCondition)
      : super((doc, context) => collectionCondition(doc.collection));

  bool Function(SQCollection) collectionCondition;
}

class DocUserCond extends DocValueCond<SQRef?> {
  DocUserCond(String fieldName, {SQRef? userRef})
      : super(fieldName,
            userRef ?? (SQAuth.isSignedIn ? SQAuth.userDoc!.ref : null));
}
