import 'package:flutter/material.dart';

import '../sq_collection.dart';
import 'types/sq_ref.dart';
import 'sq_list_field.dart';

class SQInverseRefField extends SQListField {
  SQCollection collection;
  String refFieldName;
  SQDoc? doc;

  Future<List<SQRef>> inverseRefs(SQDoc doc) async {
    if (!collection.initialized) await collection.loadCollection();

    return collection
        .filterBy([DocRefFilter(refFieldName, doc.ref)])
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
  formField({Function? onChanged, SQDoc? doc}) {
    return _InverseRefFormField(this, doc: doc);
  }

  @override
  readOnlyField({SQDoc? doc}) {
    return _InverseRefFormField(this, doc: doc);
  }
}

class _InverseRefFormField extends SQFormField {
  final SQInverseRefField inverseRefField;

  const _InverseRefFormField(this.inverseRefField, {required super.doc})
      : super(inverseRefField);

  @override
  createState() => _InverseRefFieldState();
}

class _InverseRefFieldState extends SQFormFieldState {
  List<SQRef> inverses = [];

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
