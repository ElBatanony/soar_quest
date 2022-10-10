import 'package:flutter/material.dart';

import '../sq_doc.dart';

List<T> copyList<T>(List<T> list) => list.map((e) => e).toList();

class SQListField<T> extends SQField<List<T>> {
  SQListField(
    super.name, {
    super.value,
    super.readOnly,
  });

  @override
  SQListField<T> copy() =>
      SQListField<T>(name, value: copyList(value ?? []), readOnly: readOnly);

  @override
  formField({Function? onChanged, SQDoc? doc}) {
    return _SQListFormField(this, onChanged: onChanged);
  }

  @override
  List<T>? parse(source) {
    if (source is! List) return null;
    return source.whereType<T>().toList();
  }
}

class _SQListFormField<T> extends SQFormField<SQListField<T>> {
  const _SQListFormField(super.field, {required super.onChanged});

  @override
  createState() => _SQListFormFieldState<T>();
}

class _SQListFormFieldState<T> extends SQFormFieldState<SQListField<T>> {
  @override
  Widget readOnlyBuilder(BuildContext context) {
    return Text((field.value ?? []).toString());
  }

  @override
  Widget fieldBuilder(BuildContext context) {
    throw UnimplementedError();
  }
}
