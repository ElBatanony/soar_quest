import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soar_quest/db.dart';

import 'sq_file_storage.dart';

FirebaseStorage firebaseStorage = FirebaseStorage.instance;

class FirebaseFileStorage extends SQFileStorage {
  FirebaseFileStorage(super.file);

  Reference getRef(SQDoc doc) {
    return firebaseStorage.ref().child("${doc.getPath()}/${sqFile.fieldName}");
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

    final ref = getRef(doc);

    ref
        .putFile(File(file.path), metadata)
        .snapshotEvents
        .listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.success:
          field.value.exists = true;
          print("File uploaded!!");
          onUpload();
          break;
        default:
          print(taskSnapshot.state);
      }
    });
  }

  @override
  Future getFileDownloadURL(SQDoc doc) async {
    final ref = getRef(doc);
    final fileUrl = await ref.getDownloadURL();
    return fileUrl;
  }

  @override
  Future deleteFile({required SQDoc doc, required SQFileField field}) async {
    final ref = getRef(doc);
    field.value.exists = false;
    await ref.delete();
  }
}
