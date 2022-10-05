import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../db/fields/sq_file_field.dart';
import '../db/sq_doc.dart';
import 'sq_file_storage.dart';

FirebaseStorage firebaseStorage = FirebaseStorage.instance;

class FirebaseFileStorage extends SQFileStorage {
  Reference getRef(SQDoc doc, SQFileField field) {
    return firebaseStorage.ref().child("${doc.getPath()}/${field.name}");
  }

  @override
  Future uploadFile({
    required SQDoc doc,
    required XFile file,
    required Function onUpload,
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
        .listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.success:
          field.value = true;
          print("File uploaded!!");
          onUpload();
          break;
        default:
          print(taskSnapshot.state);
      }
    });
  }

  @override
  Future getFileDownloadURL(SQDoc doc, SQFileField field) async {
    final ref = getRef(doc, field);
    final fileUrl = await ref.getDownloadURL();
    return fileUrl;
  }

  @override
  Future deleteFile({required SQDoc doc, required SQFileField field}) async {
    final ref = getRef(doc, field);
    field.value = false;
    await ref.delete();
  }
}
