import 'dart:async';

import 'package:flutter/material.dart';

import '../data/collections/collection_slice.dart';
import '../data/sq_action.dart';
import '../screens/collection_screen.dart';
import 'list_field.dart';
import 'ref_field.dart';
import 'virtual_field.dart';

class SQInverseRefsField extends SQVirtualField<List<SQRef?>> {
  SQInverseRefsField(String name,
      {required this.refCollection, required this.refFieldName})
      : super(SQListField(SQRefField(name, collection: refCollection())),
            (doc) => []);

  String refFieldName;
  SQCollection Function() refCollection;

  SQCollection get collection => refCollection();

  @override
  formField(docScreen) => _SQInverseRefsFormField(this, docScreen);
}

class _SQInverseRefsFormField
    extends SQFormField<List<SQRef?>, SQInverseRefsField> {
  _SQInverseRefsFormField(super.field, super.docScreen) {
    unawaited(initializeRefCollection());
  }

  Future<void> initializeRefCollection() async {
    if (field.collection.docs.isEmpty) await field.collection.loadCollection();
  }

  @override
  Widget fieldLabel(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          super.fieldLabel(context),
          if (isInFormScreen & field.collection.updates.adds)
            CreateDocAction('Add',
                    getCollection: () => field.collection,
                    source: (_) => {field.refFieldName: doc.ref})
                .button(doc, screen: docScreen)
        ],
      );

  @override
  Widget readOnlyBuilder(context) {
    final slice = CollectionSlice(field.collection,
        filter: RefFilter(field.refFieldName, doc.ref));
    return (CollectionScreen(collection: slice)..isInline = true).toWidget();
  }

  @override
  Widget fieldBuilder(context) {
    throw UnimplementedError();
  }
}
