import 'package:flutter/material.dart';

import 'sq_doc.dart';

typedef DocCondition = bool Function(SQDoc doc);
typedef DocContextCondition = bool Function(SQDoc doc, BuildContext context);

bool trueCond(SQDoc doc) => true;
bool falseCond(SQDoc doc) => false;

bool trueContextCond(SQDoc doc, BuildContext context) => true;
