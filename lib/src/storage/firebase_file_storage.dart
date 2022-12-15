import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/sq_doc.dart';
import 'sq_file_storage.dart';

FirebaseStorage firebaseStorage = FirebaseStorage.instance;

class FirebaseFileStorage extends SQFileStorage {
  Reference getRef(SQDoc doc, String fileFieldName) =>
      firebaseStorage.ref().child('${doc.path}/$fileFieldName');

  @override
  Future<void> uploadFile({
    required SQDoc doc,
    required XFile file,
    required VoidCallback onUpload,
    required String fileFieldName,
  }) async {
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );

    final ref = getRef(doc, fileFieldName);

    ref
        .putFile(File(file.path), metadata)
        .snapshotEvents
        .listen((taskSnapshot) async {
      debugPrint(taskSnapshot.state.toString());
      if (taskSnapshot.state == TaskState.success) {
        final downloadUrl = await ref.getDownloadURL();
        doc.setValue(fileFieldName, downloadUrl);
        debugPrint('File uploaded!!');
        onUpload();
        return;
      }
    });
  }

  @override
  Future<String> getFileDownloadURL(
      {required SQDoc doc, required String fileFieldName}) async {
    final ref = getRef(doc, fileFieldName);
    final fileUrl = await ref.getDownloadURL();
    return fileUrl;
  }

  @override
  Future<void> deleteFile(
      {required SQDoc doc, required String fileFieldName}) async {
    final ref = getRef(doc, fileFieldName);
    doc.setValue(fileFieldName, null);
    await ref.delete();
  }
}
