import '../db/sq_doc.dart';

class SQListField<T> extends SQDocField<List<T>> {
  SQListField(
    super.name, {
    List<T> list = const [],
    super.readOnly,
  }) : super(value: list);

  List<T> get list => value!;

  List<T> copyList(List<T> list) => list.map((e) => e).toList();

  @override
  SQListField<T> copy() => SQListField<T>(name, list: copyList(list));

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    throw UnimplementedError();
  }

  @override
  List<T>? parse(source) {
    if (source is! List) return null;
    return source.whereType<T>().toList();
  }
}
