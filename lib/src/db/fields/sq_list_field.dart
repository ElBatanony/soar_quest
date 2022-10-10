import '../sq_doc.dart';

List<T> copyList<T>(List<T> list) => list.map((e) => e).toList();

class SQListField<T> extends SQField<List<T>> {
  SQListField(
    super.name, {
    List<T> list = const [],
    super.readOnly,
  }) : super(value: list);

  List<T> get list => value!;

  @override
  SQListField<T> copy() => SQListField<T>(name, list: copyList(list));

  @override
  formField({Function? onChanged, SQDoc? doc}) {
    throw UnimplementedError();
  }

  @override
  List<T>? parse(source) {
    if (source is! List) return null;
    return source.whereType<T>().toList();
  }
}
