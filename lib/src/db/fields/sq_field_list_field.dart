import 'package:flutter/material.dart';

import '../sq_doc.dart';
import '../../ui/sq_button.dart';
import 'sq_list_field.dart';

class SQFieldListField extends SQListField<SQField<dynamic>> {
  List<SQField<dynamic>> allowedTypes;

  SQFieldListField(super.name, {super.value, required this.allowedTypes});

  List<SQField<dynamic>> get fields => value ?? [];

  @override
  List<SQField<dynamic>> parse(source) {
    List<dynamic> dynamicList = source as List;
    List<SQField<dynamic>> fields = [];
    for (var dynamicFieldValue in dynamicList) {
      for (SQField<dynamic> allowedType in allowedTypes) {
        var parsed = allowedType.parse(dynamicFieldValue);

        if (parsed != null &&
            parsed.runtimeType == allowedType.value.runtimeType) {
          SQField<dynamic> newField = allowedType.copy();
          newField.value = parsed;
          fields.add(newField);
          break;
        }
      }
    }
    return fields;
  }

  @override
  SQFieldListField copy() => SQFieldListField(name,
      value: copyList(fields), allowedTypes: allowedTypes);

  @override
  List<dynamic> serialize() {
    return fields.map((listItemField) => listItemField.serialize()).toList();
  }

  @override
  formField({Function? onChanged, SQDoc? doc}) {
    return _SQFieldListFormField(this, onChanged: onChanged);
  }
}

Future<SQField<dynamic>?> showFieldOptions(SQFieldListField fieldListfield,
    {required BuildContext context}) {
  return showDialog<SQField<dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Select new field type"),
            content: Wrap(
              children: [
                ...fieldListfield.allowedTypes
                    .map((field) => SQButton(
                          field.value.runtimeType.toString(),
                          onPressed: () => Navigator.pop<SQField<dynamic>>(
                              context, field.copy()),
                        ))
                    .toList(),
              ],
            ),
            actions: [
              SQButton('Cancel', onPressed: () => Navigator.pop(context)),
            ]);
      });
}

class _SQFieldListFormField extends SQFormField<SQFieldListField> {
  final SQFieldListField listField;

  const _SQFieldListFormField(this.listField, {required super.onChanged})
      : super(listField);

  @override
  createState() => _SQFieldListFormFieldState();
}

class _SQFieldListFormFieldState extends SQFormFieldState<SQFieldListField> {
  SQFieldListField get listField => field;

  void deleteListItem(int index) {
    setState(() {
      listField.fields.removeAt(index);
    });
  }

  void addField() async {
    SQField<dynamic>? newValue =
        await showFieldOptions(listField, context: context);
    if (newValue != null) {
      setState(() {
        listField.fields.add(newValue);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var listItems = listField.fields;
    var listItemsWidgets = <Widget>[];

    for (int i = 0; i < listItems.length; i++) {
      listItemsWidgets.add(Column(
        children: [
          Row(
            children: [
              Expanded(child: listItems[i].formField()),
              IconButton(
                  onPressed: () {
                    deleteListItem(i);
                  },
                  icon: Icon(Icons.delete)),
            ],
          ),
        ],
      ));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${listField.name} (List of ${listItems.length})"),
            IconButton(onPressed: addField, icon: Icon(Icons.add)),
          ],
        ),
        ...listItemsWidgets,
      ],
    );
  }
}
