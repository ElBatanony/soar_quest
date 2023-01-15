import 'package:flutter/material.dart';

import '../data/sq_field.dart';

class SQCompositeField extends SQField<Map<String, dynamic>> {
  SQCompositeField(super.name, {required this.subfields}) {
    for (final subfield in subfields) subfield.isInline = true;
  }

  final List<SQField<dynamic>> subfields;

  bool initialized = false;

  @override
  init(doc) {
    initialized = false;
    super.init(doc);
  }

  @override
  formField(docScreen) => _SQCompositeFormField(this, docScreen);
}

class _SQCompositeFormField
    extends SQFormField<Map<String, dynamic>, SQCompositeField> {
  _SQCompositeFormField(super.field, super.docScreen) {
    for (final subfield in field.subfields) {
      subFormFields.add(subfield.formField(docScreen));
    }

    final docValue = getDocValue();
    if (field.initialized != true) {
      for (final subFormField in subFormFields) {
        doc.setValue(subFormField.field.name,
            subFormField.field.parse(docValue[subFormField.field.name]));
      }

      field.initialized = true;
    }
  }

  @override
  Map<String, dynamic> getDocValue() => super.getDocValue() ?? {};

  final List<SQFormField<dynamic, SQField<dynamic>>> subFormFields = [];

  @override
  void clearDocValue() {
    for (final subFormField in subFormFields) subFormField.clearDocValue();
    super.clearDocValue();
  }

  @override
  Widget readOnlyBuilder(BuildContext context) => Column(
        children: [
          for (final subFormField in subFormFields)
            Row(
              children: [
                Text('${subFormField.field.name}: '),
                Text(subFormField.getDocValue().toString()),
              ],
            ),
        ],
      );

  void saveSerializedSubfields() {
    final docValue = <String, dynamic>{};
    for (final subFormField in subFormFields) {
      docValue[subFormField.field.name] =
          subFormField.field.serialize(subFormField.getDocValue());
    }
    doc.setValue(field.name, docValue);
  }

  @override
  Widget fieldBuilder(BuildContext context) {
    saveSerializedSubfields();
    return Column(
      children: [
        for (final subFormField in subFormFields) ...[
          Text(subFormField.field.name),
          subFormField,
        ],
      ],
    );
  }
}
