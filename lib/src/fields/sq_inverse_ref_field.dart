import 'package:flutter/material.dart';

import '../db/sq_collection.dart';
import '../db/sq_doc.dart';
import '../types/sq_doc_ref.dart';
import '../db/sq_doc_field.dart';
import 'sq_list_field.dart';

class SQInverseRefField extends SQListField {
  SQCollection collection;
  String refFieldName;
  SQDoc? doc;

  Future<List<SQDocRef>> inverseRefs(SQDoc doc) async {
    if (!collection.initialized) await collection.loadCollection();

    return collection
        .filter([DocRefFilter(refFieldName, doc.ref)])
        .map((doc) => doc.ref)
        .toList();
  }

  SQInverseRefField(super.name,
      {required this.refFieldName, this.doc, required this.collection})
      : super(readOnly: true);

  @override
  SQInverseRefField copy() {
    return SQInverseRefField(
      name,
      refFieldName: refFieldName,
      doc: doc,
      collection: collection,
    );
  }

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    return _InverseRefFormField(this, doc: doc);
  }

  @override
  DocFormField readOnlyField({SQDoc? doc}) {
    return _InverseRefFormField(this, doc: doc);
  }
}

class _InverseRefFormField extends DocFormField {
  final SQInverseRefField inverseRefField;

  const _InverseRefFormField(this.inverseRefField, {required super.doc})
      : super(inverseRefField);

  @override
  createState() => _InverseRefFieldState();
}

class _InverseRefFieldState extends DocFormFieldState {
  List<SQDocRef> inverses = [];

  SQInverseRefField get inverseRefField =>
      (widget as _InverseRefFormField).inverseRefField;

  void loadInverses() async {
    inverses = await inverseRefField.inverseRefs(doc!);
    setState(() {});
  }

  @override
  void initState() {
    loadInverses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [Text(field.name), Text(": "), Text(inverses.toString())],
    );
  }
}
