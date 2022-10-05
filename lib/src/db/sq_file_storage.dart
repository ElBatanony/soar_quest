import 'package:image_picker/image_picker.dart';

import 'fields/sq_file_field.dart';
import 'sq_doc.dart';

abstract class SQFileStorage {
  SQFile sqFile;

  SQFileStorage(this.sqFile);

  Future uploadFile({
    required SQDoc doc,
    required XFile file,
    required Function onUpload,
    required SQFileField field,
  });

  Future deleteFile({required SQDoc doc, required SQFileField field});

  Future getFileDownloadURL(SQDoc doc, SQFileField field);
}
