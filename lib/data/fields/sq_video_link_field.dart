import '../fields.dart';

class VideoLinkField extends SQDocField<String> {
  VideoLinkField(String name, {String? url, super.readOnly})
      : super(name, value: url ?? "");

  @override
  String? parse(source) {
    if (source is String) return source;
    return null;
  }

  @override
  VideoLinkField copy() => VideoLinkField(name, url: value, readOnly: readOnly);
}
