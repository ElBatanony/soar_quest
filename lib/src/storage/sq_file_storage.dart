import 'package:image_picker/image_picker.dart';

import 'sq_file_field.dart';
import '../db/sq_doc.dart';

abstract class SQFileStorage {
  Future<void> uploadFile({
    required SQDoc doc,
    required XFile file,
    required Function onUpload,
    required SQFileField field,
  });

  Future<void> deleteFile({required SQDoc doc, required SQFileField field});

  Future<String> getFileDownloadURL(SQDoc doc, SQFileField field);
}
