import 'db.dart';

export 'fields/sq_field_list_field.dart';
export 'fields/sq_doc_ref_field.dart';
export 'fields/sq_file_field.dart';
export 'fields/sq_time_of_day_field.dart';
export 'fields/sq_timestamp_field.dart';
export 'fields/sq_user_ref_field.dart';
export 'fields/sq_updated_date_field.dart';
export 'fields/sq_string_field.dart';
export 'fields/sq_bool_field.dart';
export 'fields/sq_int_field.dart';
export 'fields/sq_video_link_field.dart';
export 'fields/sq_double_field.dart';
export 'fields/sq_list_field.dart';
export 'fields/sq_inverse_ref_field.dart';

export '../data/db/sq_doc.dart';
export '../components/doc_form_field.dart';

abstract class SQDocField<T> {
  String name = "";
  T? value;
  Type get type => T;
  bool readOnly;
  bool required;

  SQDocField(
    this.name, {
    this.value,
    this.readOnly = false,
    this.required = false,
  });

  SQDocField copy();

  dynamic collectField() => value;

  T? parse(dynamic source);

  DocFormField formField({Function? onChanged, SQDoc? doc});

  DocFormField readOnlyField({SQDoc? doc}) {
    return ReadOnlyFormField(this, doc: doc);
  }

  @override
  String toString() {
    return "${name == "" ? "" : "$name:"} $value";
  }

  bool get isNull => value == null;
}
