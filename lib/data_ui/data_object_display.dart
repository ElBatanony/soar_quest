import 'package:flutter/material.dart';
import 'package:soar_quest/data_objects/data_object.dart';

class DataFieldDisplay extends StatelessWidget {
  final DataField field;
  const DataFieldDisplay(this.field, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text('${field.name}: ${field.value} , ${field.type.name}')],
    );
  }
}

class DataObjectDisplay extends StatelessWidget {
  final DataObject object;

  const DataObjectDisplay(this.object, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: object.collection?.diplayScreen?.dataObjectDisplayBody == null
          ? dataObjectDisplayBody(object)
          : object.collection?.diplayScreen?.dataObjectDisplayBody!(object),
    );
  }
}

Widget dataObjectDisplayBody(DataObject object) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: object.fields.map((field) => DataFieldDisplay(field)).toList());
}
