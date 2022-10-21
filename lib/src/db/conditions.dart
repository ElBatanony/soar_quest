import 'sq_doc.dart';

typedef DocCondition = bool Function(SQDoc doc);

bool trueCond(SQDoc doc) => true;
bool falseCond(SQDoc doc) => false;
