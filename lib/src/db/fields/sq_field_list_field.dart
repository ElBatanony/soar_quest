import 'package:flutter/material.dart';

import '../../screens/screen.dart';
import '../sq_doc.dart';
import '../../ui/sq_button.dart';
import 'sq_list_field.dart';

class SQFieldListField extends SQListField<SQField> {
  List<SQField> allowedTypes;

  SQFieldListField(super.name,
      {List<SQField> list = const <SQField>[], required this.allowedTypes})
      : super(list: list);

  List<SQField> get fields => list;

  @override
  List<SQField> parse(source) {
    List<dynamic> dynamicList = source as List;
    List<SQField> fields = [];
    for (var dynamicFieldValue in dynamicList) {
      for (SQField allowedType in allowedTypes) {
        var parsed = allowedType.parse(dynamicFieldValue);

        if (parsed != null &&
            parsed.runtimeType == allowedType.value.runtimeType) {
          SQField newField = allowedType.copy();
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
      list: fields.map((e) => e.copy()).toList(), allowedTypes: allowedTypes);

  @override
  List<dynamic> serialize() {
    return fields.map((listItemField) => listItemField.serialize()).toList();
  }

  @override
  formField({Function? onChanged, SQDoc? doc}) {
    return _SQFieldListFormField(this, onChanged: onChanged);
  }
}

Future showFieldOptions(SQFieldListField fieldListfield,
    {required BuildContext context}) {
  return showDialog<SQField>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Select new field type"),
            content: Wrap(
              children: [
                ...fieldListfield.allowedTypes
                    .map((field) => SQButton(field.value.runtimeType.toString(),
                        onPressed: () =>
                            exitScreen(context, value: field.copy())))
                    .toList(),
              ],
            ),
            actions: [
              SQButton('Cancel', onPressed: () => exitScreen(context)),
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
    SQField? newValue = await showFieldOptions(listField, context: context);
    if (newValue != null) {
      setState(() {
        listField.fields.add(newValue);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var listItems = listField.fields;
    var listItemsWidgets = [];

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
