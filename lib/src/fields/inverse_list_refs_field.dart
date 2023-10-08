import 'dart:async';

import 'package:flutter/material.dart';

import '../data/collections/collection_slice.dart';
import '../screens/collection_screen.dart';
import 'list_field.dart';
import 'ref_field.dart';
import 'virtual_field.dart';

class SQInverseListRefsField extends SQVirtualField<List<SQRef?>> {
  SQInverseListRefsField(String name,
      {required this.refCollection, required this.refFieldName})
      : super(SQListField(SQRefField(name, collection: refCollection())),
            (doc) => []);

  String refFieldName;
  SQCollection Function() refCollection;

  SQCollection get collection => refCollection();

  @override
  formField(docScreen) => _SQInverseListRefsFormField(this, docScreen);
}

class _SQInverseListRefsFormField
    extends SQFormField<List<SQRef?>, SQInverseListRefsField> {
  _SQInverseListRefsFormField(super.field, super.docScreen) {
    unawaited(initializeRefCollection());
  }

  Future<void> initializeRefCollection() async {
    if (field.collection.docs.isEmpty) await field.collection.loadCollection();
  }

  @override
  Widget readOnlyBuilder(context) {
    final slice = CollectionSlice(
      field.collection,
      filter: CustomFilter((otherDoc) =>
          otherDoc
              .getValue<List<SQRef?>>(field.refFieldName)
              ?.contains(doc.ref) ??
          false),
    );
    return (CollectionScreen(collection: slice)..isInline = true).toWidget();
  }

  @override
  Widget fieldBuilder(context) {
    throw UnimplementedError();
  }
}
