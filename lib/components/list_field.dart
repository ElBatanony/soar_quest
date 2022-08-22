import 'package:flutter/material.dart';
import 'package:soar_quest/data/sq_doc.dart';

import 'doc_field_field.dart';

class ListField extends StatefulWidget {
  final SQDocListField listField;

  const ListField(this.listField, {Key? key}) : super(key: key);

  @override
  State<ListField> createState() => _ListFieldState();
}

class _ListFieldState extends State<ListField> {
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
      listItemsWidgets.add(ListItemField(listItems[i], deleteItem: () {
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
  final SQDocField listItemField;
  final Function deleteItem;

  const ListItemField(this.listItemField, {required this.deleteItem, Key? key})
      : super(key: key);

  @override
  State<ListItemField> createState() => _ListItemFieldState();
}

class _ListItemFieldState extends State<ListItemField> {
  @override
  Widget build(BuildContext context) {
    var typesWithoutList = sQDocFieldTypes.where((type) => type != List);

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
                      // widget.listItemField.type = value;
                      widget.listItemField.value =
                          widget.listItemField.defaultValue;
                    }
                  });
                })),
            Expanded(child: DocFieldField(widget.listItemField)),
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
