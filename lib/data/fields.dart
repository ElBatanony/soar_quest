export 'fields/sq_doc_field.dart';

export 'fields/doc_list_field.dart';
export 'fields/sq_doc_reference_field.dart';
export 'fields/sq_file_field.dart';
export 'fields/sq_time_of_day_field.dart';
export 'fields/sq_timestamp_field.dart';
export 'fields/sq_user_ref_field.dart';
export 'fields/updated_date_field.dart';

abstract class SQDocField<T> {
  String name = "";
  T? value;
  Type get type => T;
  final bool readOnly;

  SQDocField(this.name, {this.value, this.readOnly = false});

  SQDocField copy();

  dynamic collectField() => value;

  T? parse(dynamic source);

  @override
  String toString() {
    return "${name == "" ? "" : "$name:"} $value";
  }
}
