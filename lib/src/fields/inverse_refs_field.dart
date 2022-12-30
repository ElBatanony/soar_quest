import 'dart:async';

import 'package:flutter/material.dart';

import '../data/collections/collection_slice.dart';
import '../data/sq_action.dart';
import '../screens/collection_screens/table_screen.dart';
import 'list_field.dart';
import 'virtual_field.dart';

class SQInverseRefsField extends SQVirtualField<List<SQDoc>> {
  SQInverseRefsField(String name,
      {required this.refCollection, required this.refFieldName})
      : super(SQListField(name), (doc) => []);

  String refFieldName;
  SQCollection Function() refCollection;

  SQCollection get collection => refCollection();

  @override
  formField(docScreen) => _SQInverseRefsFormField(
        this,
        docScreen,
        refDocs: valueBuilder(docScreen.doc),
      );
}

class _SQInverseRefsFormField
    extends SQFormField<List<SQDoc>, SQInverseRefsField> {
  _SQInverseRefsFormField(super.field, super.docScreen,
      {required this.refDocs}) {
    unawaited(initializeRefCollection());
  }

  Future<void> initializeRefCollection() async {
    if (field.collection.docs.isEmpty) await field.collection.loadCollection();
  }

  final List<SQDoc> refDocs;

  @override
  Widget fieldLabel(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          super.fieldLabel(context),
          if (field.collection.updates.adds)
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
    return (TableScreen(collection: slice)..isInline = true).toWidget();
  }

  @override
  Widget fieldBuilder(context) {
    throw UnimplementedError();
  }
}
