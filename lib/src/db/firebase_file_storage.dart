import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'sq_file_storage.dart';
import 'sq_doc.dart';

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
          sqFile.getFileField(doc)?.value.exists = true;
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
  Future deleteFile({required SQDoc doc}) async {
    final ref = getRef(doc);
    sqFile.getFileField(doc)?.value.exists = false;
    await ref.delete();
  }
}
