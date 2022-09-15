import 'package:flutter/material.dart';

import '../../data.dart';
import '../doc_form_field.dart';

class ListFieldField extends StatefulWidget {
  final SQDocListField listField;

  const ListFieldField(this.listField, {Key? key}) : super(key: key);

  @override
  State<ListFieldField> createState() => _ListFieldFieldState();
}

class _ListFieldFieldState extends State<ListFieldField> {
  void deleteListItem(int index) {
    setState(() {
      widget.listField.value.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    var listItems = widget.listField.value;
    var listItemsWidgets = [];

    for (int i = 0; i < listItems.length; i++) {
      listItemsWidgets.add(ListItemField(listItems[i],
          listField: widget.listField, deleteItem: () {
        deleteListItem(i);
      }));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${widget.listField.name} (List of ${listItems.length})"),
            IconButton(
              onPressed: () {
                setState(() {
                  widget.listField.value.add(SQStringField(""));
                });
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
        ...listItemsWidgets,
      ],
    );
  }
}

class ListItemField extends StatefulWidget {
  final SQDocListField listField;
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
    var typesWithoutList =
        widget.listField.allowedTypes.where((type) => type != List);

    return Column(
      children: [
        Row(
          children: [
            DropdownButton<Type>(
                value: widget.listItemField.type,
                items: typesWithoutList
                    .map((type) => DropdownMenuItem<Type>(
                          value: type,
                          child: Text(type.toString()),
                        ))
                    .toList(),
                onChanged: ((value) {
                  setState(() {
                    if (value != null) {
                      widget.listItemField.value = null;
                    }
                  });
                })),
            Expanded(child: DocFormField(widget.listItemField)),
            IconButton(
              onPressed: () {
                widget.deleteItem();
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ],
    );
  }
}
