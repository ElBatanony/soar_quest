import 'dart:async';

import 'package:flutter/material.dart';

import '../../screens/collection_screens/table_screen.dart';
import '../collections/collection_slice.dart';
import '../sq_action.dart';
import 'sq_list_field.dart';
import 'sq_ref_field.dart';
import 'sq_virtual_field.dart';

class SQInverseRefsField extends SQVirtualField<List<SQDoc>> {
  String refFieldName;
  SQCollection Function() refCollection;

  SQCollection get collection => refCollection();

  SQInverseRefsField(String name,
      {required this.refCollection, required this.refFieldName})
      : super(field: SQListField(name), valueBuilder: (doc) => []);

  @override
  SQInverseRefsField copy() => SQInverseRefsField(name,
      refCollection: refCollection, refFieldName: refFieldName);

  @override
  formField(SQDoc doc, {VoidCallback? onChanged}) {
    return _SQInverseRefsFormField(this, doc,
        refDocs: valueBuilder(doc), onChanged: onChanged);
  }
}

class _SQInverseRefsFormField extends SQFormField<SQInverseRefsField> {
  final List<SQDoc> refDocs;
  const _SQInverseRefsFormField(super.field, super.doc,
      {required this.refDocs, required super.onChanged});

  @override
  createState() => _SQInverseRefsFormFieldState();
}

class _SQInverseRefsFormFieldState
    extends SQFormFieldState<SQInverseRefsField> {
  Future<void> initializeRefCollection() async {
    if (field.collection.docs.isEmpty) await field.collection.loadCollection();
    onChanged();
  }

  @override
  void initState() {
    unawaited(initializeRefCollection());
    super.initState();
  }

  @override
  Widget fieldLabel(ScreenState screenState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        super.fieldLabel(screenState),
        if (field.collection.updates.adds)
          CreateDocAction('Add',
              getCollection: () => field.collection,
              initialFields: (_) => [
                    SQRefField(field.refFieldName,
                        collection: doc.collection,
                        value: doc.ref,
                        editable: false)
                  ]).button(doc, screenState: screenState)
      ],
    );
  }

  @override
  Widget readOnlyBuilder(ScreenState screenState) {
    final slice = CollectionSlice(field.collection,
        filter: RefFilter(field.refFieldName, doc.ref));
    return TableScreen(collection: slice, isInline: true);
  }

  @override
  Widget fieldBuilder(ScreenState screenState) {
    throw UnimplementedError();
  }
}
