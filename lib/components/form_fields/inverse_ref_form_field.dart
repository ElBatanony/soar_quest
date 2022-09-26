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
  @override
  Widget build(BuildContext context) {
    List<SQDocRef> inverses = widget.inverseRefField.inverseRefs(widget.doc!);

    return Wrap(
      children: [
        Text(widget.field.name),
        Text(": "),
        Text(inverses.toString())
      ],
    );
  }
}
