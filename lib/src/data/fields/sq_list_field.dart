import 'package:flutter/material.dart';

import '../sq_doc.dart';

List<T> copyList<T>(List<T> list) => list.map((e) => e).toList();

class SQListField<T> extends SQField<List<T>> {
  SQListField(
    super.name, {
    super.defaultValue,
    super.editable,
  });

  @override
  formField(docScreenState) => _SQListFormField(this, docScreenState);

  @override
  List<T>? parse(source) {
    if (source is! List) return null;
    return super.parse(source) ?? source.whereType<T>().toList();
  }
}

class _SQListFormField<T> extends SQFormField<List<T>, SQListField<T>> {
  const _SQListFormField(super.field, super.docScreenState);

  @override
  Widget readOnlyBuilder(context) => Text((getDocValue() ?? []).toString());

  @override
  Widget fieldBuilder(context) {
    throw UnimplementedError();
  }
}
