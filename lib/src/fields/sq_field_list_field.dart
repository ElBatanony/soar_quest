import 'package:flutter/material.dart';

import '../../app.dart';
import '../ui/buttons/sq_button.dart';
import '../../data/fields.dart';

class SQFieldListField extends SQListField<SQDocField> {
  List<SQDocField> allowedTypes;

  SQFieldListField(super.name,
      {List<SQDocField> list = const <SQDocField>[],
      required this.allowedTypes})
      : super(list: list);

  @override
  Type get type => List;

  List<SQDocField> get fields => list;

  @override
  List<SQDocField> parse(source) {
    List<dynamic> dynamicList = source as List;
    List<SQDocField> fields = [];
    for (var dynamicFieldValue in dynamicList) {
      for (SQDocField allowedType in allowedTypes) {
        var parsed = allowedType.parse(dynamicFieldValue);

        if (parsed != null && parsed.runtimeType == allowedType.type) {
          SQDocField newField = allowedType.copy();
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
  List<dynamic> collectField() {
    return fields.map((listItemField) => listItemField.collectField()).toList();
  }

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    return _SQFieldListFormField(this, onChanged: onChanged);
  }
}

Future showFieldOptions(SQFieldListField fieldListfield,
    {required BuildContext context}) {
  return showDialog<SQDocField>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Select new field type"),
            content: Wrap(
              children: [
                ...fieldListfield.allowedTypes
                    .map((field) => SQButton(field.type.toString(),
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

class _SQFieldListFormField extends DocFormField<SQFieldListField> {
  final SQFieldListField listField;

  const _SQFieldListFormField(this.listField, {required super.onChanged})
      : super(listField);

  @override
  createState() => _SQFieldListFormFieldState();
}

class _SQFieldListFormFieldState extends DocFormFieldState<SQFieldListField> {
  SQFieldListField get listField => field;

  void deleteListItem(int index) {
    setState(() {
      listField.fields.removeAt(index);
    });
  }

  void addField() async {
    SQDocField? newValue = await showFieldOptions(listField, context: context);
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
