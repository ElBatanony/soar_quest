import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/fields/sq_file_field.dart';
import '../data/sq_doc.dart';
import 'sq_file_storage.dart';

FirebaseStorage firebaseStorage = FirebaseStorage.instance;

class FirebaseFileStorage extends SQFileStorage {
  Reference getRef(SQDoc doc, SQFileField field) =>
      firebaseStorage.ref().child('${doc.path}/${field.name}');

  @override
  Future<void> uploadFile({
    required SQDoc doc,
    required XFile file,
    required VoidCallback onUpload,
    required SQFileField field,
  }) async {
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );

    final ref = getRef(doc, field);

    ref
        .putFile(File(file.path), metadata)
        .snapshotEvents
        .listen((taskSnapshot) async {
      debugPrint(taskSnapshot.state.toString());
      if (taskSnapshot.state == TaskState.success) {
        final downloadUrl = await ref.getDownloadURL();
        field.value = downloadUrl;
        debugPrint('File uploaded!!');
        onUpload();
        return;
      }
    });
  }

  @override
  Future<String> getFileDownloadURL(SQDoc doc, SQFileField field) async {
    final ref = getRef(doc, field);
    final fileUrl = await ref.getDownloadURL();
    return fileUrl;
  }

  @override
  Future<void> deleteFile(
      {required SQDoc doc, required SQFileField field}) async {
    final ref = getRef(doc, field);
    field.value = null;
    await ref.delete();
  }
}
