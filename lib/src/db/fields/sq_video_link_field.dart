import 'package:flutter/material.dart';

import '../../screens/collection_screens/video_screen.dart';
import '../sq_doc.dart';
import 'sq_string_field.dart';
import 'sq_text_field.dart';

class VideoLinkField extends SQStringField {
  VideoLinkField(String name, {String? url, super.editable})
      : super(name, value: url ?? "");

  @override
  String? parse(source) {
    if (source is String) return source;
    return null;
  }

  @override
  VideoLinkField copy() => VideoLinkField(name, url: value, editable: editable);

  @override
  formField({Function? onChanged, SQDoc? doc}) {
    return _VideoLinkFormField(this, onChanged: onChanged, doc: doc);
  }
}

class _VideoLinkFormField extends SQFormField<VideoLinkField> {
  const _VideoLinkFormField(super.field,
      {required super.onChanged, required super.doc});

  @override
  createState() => __VideoLinkFormFieldState();
}

class __VideoLinkFormFieldState extends SQFormFieldState<VideoLinkField> {
  @override
  Widget readOnlyBuilder(BuildContext context) {
    if (formField.doc == null) return super.readOnlyBuilder(context);
    return VideoDocDisplay(formField.doc!, videoField: field);
  }

  @override
  Widget fieldBuilder(BuildContext context) {
    return SQTextField(formField, textParse: (text) => text);
  }
}
