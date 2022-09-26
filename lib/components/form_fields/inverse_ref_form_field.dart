import 'package:flutter/material.dart';

import '../../data/db.dart';
import '../../data/types.dart';

class InverseRefFormField extends DocFormField {
  final SQInverseRefField inverseRefField;

  const InverseRefFormField(this.inverseRefField,
      {super.onChanged, required super.doc, super.key})
      : super(inverseRefField);

  @override
  State<InverseRefFormField> createState() => _InverseRefFieldState();
}

class _InverseRefFieldState extends DocFormFieldState<InverseRefFormField> {
  List<SQDocRef> inverses = [];

  void loadInverses() async {
    inverses = await widget.inverseRefField.inverseRefs(widget.doc!);
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
      children: [
        Text(widget.field.name),
        Text(": "),
        Text(inverses.toString())
      ],
    );
  }
}
