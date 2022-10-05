import 'package:image_picker/image_picker.dart';

import 'fields/types/sq_file.dart';
import 'sq_doc.dart';

abstract class SQFileStorage {
  SQFile sqFile;

  SQFileStorage(this.sqFile);

  Future uploadFile({
    required SQDoc doc,
    required XFile file,
    required Function onUpload,
  });

  Future deleteFile({required SQDoc doc});

  Future getFileDownloadURL(SQDoc doc);
}
