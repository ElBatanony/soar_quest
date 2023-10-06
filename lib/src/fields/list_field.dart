import 'package:flutter/material.dart';

import '../data/sq_field.dart';
import '../ui/button.dart';

class SQListField<T> extends SQField<List<T?>> {
  SQListField(this.subfield, {this.inverseInsert = true})
      : super(subfield.name) {
    subfield
      ..isInline = true
      ..name = '_${subfield.name}_';
  }

  SQField<T> subfield;
  bool inverseInsert;

  int _isEditIndex = -1;

  @override
  formField(docScreen) => _SQListFormField(this, docScreen);

  @override
  List<T?>? parse(source) {
    super.parse(source);
    if (source is! List) return null;
    return source.map((listItem) => subfield.parse(listItem)).toList();
  }

  @override
  serialize(List<T?>? value) {
    if (value == null) return null;
    return value.map((listItem) => subfield.serialize(listItem)).toList();
  }
}

class _SQListFormField<T> extends SQFormField<List<T?>, SQListField<T>> {
  const _SQListFormField(super.field, super.docScreen);

  List<T?> get listValues => getDocValue() ?? [];
  bool get isEditing => field._isEditIndex >= 0;

  @override
  Widget readOnlyBuilder(context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: listValues.map((value) => Text(value.toString())).toList(),
      );

  @override
  Widget fieldBuilder(context) => Column(
        children: [
          Row(
            children: [
              Expanded(child: field.subfield.formField(docScreen)),
              SQButton.icon(isEditing ? Icons.save : Icons.add, onPressed: () {
                final newValue = docScreen.doc.getValue<T>(field.subfield.name);
                if (newValue != null) {
                  if (isEditing) {
                    listValues[field._isEditIndex] = newValue;
                    field._isEditIndex = -1;
                  } else {
                    if (field.inverseInsert)
                      listValues.insert(0, newValue);
                    else
                      listValues.add(newValue);
                  }
                  setDocValue(listValues);
                }
                docScreen.doc
                    .setValue(field.subfield.name, field.subfield.defaultValue);
              }),
            ],
          ),
          for (var i = 0; i < listValues.length; i += 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(listValues[i].toString()),
                Row(
                  children: [
                    if (!isEditing)
                      SQButton.icon(Icons.edit, onPressed: () {
                        docScreen.doc
                            .setValue(field.subfield.name, listValues[i]);
                        field._isEditIndex = i;
                        setDocValue(listValues);
                      }),
                    SQButton.icon(Icons.delete, onPressed: () {
                      listValues.removeAt(i);
                      setDocValue(listValues);
                    })
                  ],
                )
              ],
            ),
        ],
      );
}
