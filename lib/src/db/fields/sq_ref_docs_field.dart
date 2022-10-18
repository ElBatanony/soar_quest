import 'package:flutter/material.dart';

import '../../ui/sq_button.dart';
import '../../../screens.dart';
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
  formField({Function? onChanged, SQDoc? doc}) {
    return _SQRefDocsFormField(
      this,
      refDocs: valueBuilder(doc!),
      onChanged: onChanged,
      doc: doc,
    );
  }
}

class _SQRefDocsFormField extends SQFormField<SQRefDocsField> {
  final List<SQDoc> refDocs;
  const _SQRefDocsFormField(super.field,
      {required this.refDocs, required super.onChanged, required super.doc});

  @override
  createState() => _SQRefDocsFormFieldState();
}

class _SQRefDocsFormFieldState extends SQFormFieldState<SQRefDocsField> {
  Future<void> initializeRefCollection() async {
    if (field.collection.initialized == false)
      await field.collection.loadCollection();
    onChanged();
  }

  @override
  void initState() {
    initializeRefCollection();
    super.initState();
  }

  @override
  Widget readOnlyBuilder(BuildContext context) {
    List<SQDoc> refDocs = (formField as _SQRefDocsFormField).refDocs;
    return Column(
      children: [
        Table(border: TableBorder.all(), children: [
          TableRow(children: [Text(field.collection.fields[0].name)]),
          ...refDocs
              .map((refDoc) => TableRow(children: [Text(refDoc.toString())]))
              .toList(),
        ]),
        SQButton("Add", onPressed: () async {
          SQDoc newDoc = field.collection.newDoc(initialFields: [
            SQRefField(field.refFieldName,
                collection: doc!.collection, value: doc!.ref, editable: false)
          ]);
          await FormScreen(newDoc).go(context);
          setState(() {});
        })
      ],
    );
  }
}
