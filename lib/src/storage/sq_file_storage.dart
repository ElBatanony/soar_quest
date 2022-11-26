import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/fields/sq_file_field.dart';
import '../data/sq_doc.dart';

abstract class SQFileStorage {
  Future<void> uploadFile({
    required SQDoc doc,
    required XFile file,
    required VoidCallback onUpload,
    required SQFileField field,
  });

  Future<void> deleteFile({required SQDoc doc, required SQFileField field});

  Future<String> getFileDownloadURL(SQDoc doc, SQFileField field);
}
