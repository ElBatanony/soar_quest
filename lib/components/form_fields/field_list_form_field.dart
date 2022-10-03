import 'package:flutter/material.dart';

import '../../app/app_navigator.dart';
import '../../data/fields.dart';
import '../buttons/sq_button.dart';

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

class SQFieldListFormField extends DocFormField<SQFieldListField> {
  final SQFieldListField listField;

  const SQFieldListFormField(this.listField,
      {super.doc, required super.onChanged, super.key})
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
      listItemsWidgets.add(
          ListItemField(listItems[i], listField: listField, deleteItem: () {
        deleteListItem(i);
      }));
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

class ListItemField extends StatefulWidget {
  final SQFieldListField listField;
  final SQDocField listItemField;
  final Function deleteItem;

  const ListItemField(this.listItemField,
      {required this.deleteItem, required this.listField, Key? key})
      : super(key: key);

  @override
  State<ListItemField> createState() => _ListItemFieldState();
}

class _ListItemFieldState extends State<ListItemField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: widget.listItemField.formField()),
            IconButton(
                onPressed: () => widget.deleteItem(), icon: Icon(Icons.delete)),
          ],
        ),
      ],
    );
  }
}
