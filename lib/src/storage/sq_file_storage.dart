import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/sq_doc.dart';

abstract class SQFileStorage {
  Future<void> uploadFile({
    required SQDoc doc,
    required XFile file,
    required VoidCallback onUpload,
    required String fileFieldName,
  });

  Future<void> deleteFile({required SQDoc doc, required String fileFieldName});

  Future<String> getFileDownloadURL(
      {required SQDoc doc, required String fileFieldName});
}
