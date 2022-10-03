import 'package:flutter/material.dart';

import '../../data/db.dart';
import '../../data/types.dart';

class InverseRefFormField extends DocFormField {
  final SQInverseRefField inverseRefField;

  const InverseRefFormField(this.inverseRefField,
      {super.onChanged, required super.doc, super.key})
      : super(inverseRefField);

  @override
  createState() => _InverseRefFieldState();
}

class _InverseRefFieldState extends DocFormFieldState {
  List<SQDocRef> inverses = [];

  SQInverseRefField get inverseRefField =>
      (widget as InverseRefFormField).inverseRefField;

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
