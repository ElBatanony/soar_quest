import '../../screens/collection_screens/video_screen.dart';
import '../../ui/text_field.dart';
import '../sq_field.dart';
import 'string_field.dart';

class SQVideoLinkField extends SQStringField {
  SQVideoLinkField(super.name, {String? url, super.editable})
      : super(defaultValue: url ?? '');

  @override
  formField(docScreenState) => _SQVideoLinkFormField(this, docScreenState);
}

class _SQVideoLinkFormField extends SQFormField<String, SQVideoLinkField> {
  const _SQVideoLinkFormField(super.field, super.docScreenState);

  @override
  readOnlyBuilder(context) =>
      VideoDocDisplay(doc, videoField: field).toWidget();

  @override
  fieldBuilder(context) => SQTextField(this, textParse: (text) => text);
}
