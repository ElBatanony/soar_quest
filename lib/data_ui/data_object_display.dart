import 'package:flutter/material.dart';
import 'package:soar_quest/data_objects/sq_doc.dart';

class DataFieldDisplay extends StatelessWidget {
  final SQDocField field;
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
  final SQDoc object;

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

Widget dataObjectDisplayBody(SQDoc object) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: object.fields.map((field) => DataFieldDisplay(field)).toList());
}
