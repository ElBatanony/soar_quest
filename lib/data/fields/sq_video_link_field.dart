import '../fields.dart';

class VideoLinkField extends SQStringField {
  VideoLinkField(String name, {String? url, super.readOnly})
      : super(name, value: url ?? "");

  @override
  String? parse(source) {
    if (source is String) return source;
    return null;
  }

  @override
  VideoLinkField copy() => VideoLinkField(name, url: value, readOnly: readOnly);

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    return SQStringFormField(this, onChanged: onChanged);
  }
}
