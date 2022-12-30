import '../../screens/collection_screens/video_screen.dart';
import '../../ui/text_field.dart';
import '../sq_field.dart';
import 'string_field.dart';

class SQVideoLinkField extends SQStringField {
  SQVideoLinkField(super.name);

  @override
  formField(docScreen) => _SQVideoLinkFormField(this, docScreen);
}

class _SQVideoLinkFormField extends SQFormField<String, SQVideoLinkField> {
  const _SQVideoLinkFormField(super.field, super.docScreen);

  @override
  readOnlyBuilder(context) =>
      VideoDocDisplay(doc, videoField: field).toWidget();

  @override
  fieldBuilder(context) => SQTextField(this, textParse: (text) => text);
}
