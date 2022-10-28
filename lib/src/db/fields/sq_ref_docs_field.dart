import 'package:flutter/material.dart';

import '../../../screens.dart';
import '../../ui/sq_button.dart';
import '../collection_slice.dart';
import '../sq_collection.dart';
import 'sq_list_field.dart';
import 'sq_ref_field.dart';
import 'sq_virtual_field.dart';

class SQRefDocsField extends SQVirtualField<List<SQDoc>> {
  String refFieldName;
  SQCollection Function() refCollection;

  SQCollection get collection => refCollection();

  SQRefDocsField(String name,
      {required this.refCollection, required this.refFieldName})
      : super(
            field: SQListField(name),
            valueBuilder: (doc) => refCollection()
                .filterBy([DocRefFilter(refFieldName, doc.ref)]));

  @override
  SQRefDocsField copy() => SQRefDocsField(name,
      refCollection: refCollection, refFieldName: refFieldName);

  @override
  formField(SQDoc doc, {Function? onChanged}) {
    return _SQRefDocsFormField(this, doc,
        refDocs: valueBuilder(doc), onChanged: onChanged);
  }
}

class _SQRefDocsFormField extends SQFormField<SQRefDocsField> {
  final List<SQDoc> refDocs;
  const _SQRefDocsFormField(super.field, super.doc,
      {required this.refDocs, required super.onChanged});

  @override
  createState() => _SQRefDocsFormFieldState();
}

class _SQRefDocsFormFieldState extends SQFormFieldState<SQRefDocsField> {
  Future<void> initializeRefCollection() async {
    if (field.collection.docs.isEmpty) await field.collection.loadCollection();
    onChanged();
  }

  @override
  void initState() {
    initializeRefCollection();
    super.initState();
  }

  @override
  Widget fieldLabel(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        super.fieldLabel(context),
        if (field.collection.adds)
          SQButton("Add", onPressed: () async {
            SQDoc newDoc = field.collection.newDoc(initialFields: [
              SQRefField(field.refFieldName,
                  collection: doc.collection, value: doc.ref, editable: false)
            ]);
            await FormScreen(newDoc).go(context);
            setState(() {});
          })
      ],
    );
  }

  @override
  Widget readOnlyBuilder(BuildContext context) {
    CollectionSlice slice = CollectionSlice(field.collection,
        filter: DocRefFilter(field.refFieldName, doc.ref));
    return TableScreen(collection: slice, isInline: true);
  }

  @override
  Widget fieldBuilder(BuildContext context) {
    throw UnimplementedError();
  }
}
