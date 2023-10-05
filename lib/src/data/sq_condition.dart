import '../screens/form_screen.dart';
import '../screens/screen.dart';
import 'sq_collection.dart';

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

class DocValueCond<T> extends DocCond {
  DocValueCond(String fieldName, T expectedValue)
      : super((doc, context) => doc.getValue<T>(fieldName) == expectedValue);
}

class CollectionCond extends DocCond {
  CollectionCond(this.collectionCondition)
      : super((doc, context) => collectionCondition(doc.collection));

  bool Function(SQCollection) collectionCondition;
}
