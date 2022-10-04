import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../sq_doc.dart';
import '../fields/sq_file_field.dart';

FirebaseStorage firebaseStorage = FirebaseStorage.instance;

class SQFile {
  String fieldName;
  bool exists;

  SQFile({
    required this.fieldName,
    this.exists = false,
  });

  static SQFile? parse(dynamic source) {
    bool exists = source["exists"] ?? false;
    String? fieldName = source["fieldName"];

    if (fieldName == null) return null;

    return SQFile(fieldName: fieldName, exists: exists);
  }

  SQFileField? getFileField(SQDoc doc) {
    return doc.getField(fieldName) as SQFileField;
  }

  @override
  String toString() {
    return exists ? "file" : "file not set";
  }
}

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
          sqFile.getFileField(doc)?.sqFile.exists = true;
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
    sqFile.getFileField(doc)?.sqFile.exists = false;
    await ref.delete();
  }
}
