import 'dart:async';

import 'package:flutter/material.dart';

import '../../screens/collection_screens/table_screen.dart';
import '../collections/collection_slice.dart';
import '../sq_action.dart';
import 'sq_list_field.dart';
import 'sq_virtual_field.dart';

class SQInverseRefsField extends SQVirtualField<List<SQDoc>> {
  SQInverseRefsField(String name,
      {required this.refCollection, required this.refFieldName})
      : super(field: SQListField(name), valueBuilder: (doc) => []);

  String refFieldName;
  SQCollection Function() refCollection;

  SQCollection get collection => refCollection();

  @override
  formField(docScreenState) => _SQInverseRefsFormField(
        this,
        docScreenState,
        refDocs: valueBuilder(docScreenState.doc),
      );
}

class _SQInverseRefsFormField
    extends SQFormField<List<SQDoc>, SQInverseRefsField> {
  _SQInverseRefsFormField(super.field, super.docScreenState,
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
                .button(doc, screenState: docScreenState)
        ],
      );

  @override
  Widget readOnlyBuilder(context) {
    final slice = CollectionSlice(field.collection,
        filter: RefFilter(field.refFieldName, doc.ref));
    return TableScreen(collection: slice, isInline: true);
  }

  @override
  Widget fieldBuilder(context) {
    throw UnimplementedError();
  }
}
