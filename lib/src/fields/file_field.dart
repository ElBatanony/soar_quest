import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/firebase_file_storage.dart';
import '../data/sq_doc.dart';
import '../data/sq_file_storage.dart';
import '../ui/button.dart';

class SQFileField extends SQField<String> {
  SQFileField(super.name, {SQFileStorage? storage}) {
    this.storage = storage ?? FirebaseFileStorage();
  }

  late SQFileStorage storage;

  bool fileExists(SQDoc doc) => downloadUrl(doc) != null;

  String? downloadUrl(SQDoc doc) => doc.getValue<String>(name);

  @override
  formField(docScreen) => SQFileFormField(this, docScreen);
}

class SQFileFormField<FileField extends SQFileField>
    extends SQFormField<String, FileField> {
  const SQFileFormField(super.field, super.docScreen);

  Future<void> openFileUrl() async {
    if (field.downloadUrl(doc) == null)
      throw Exception('Download URL for ${field.name} is null');
    if (!await launchUrl(Uri.parse(field.downloadUrl(doc)!),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch ${field.downloadUrl}');
    }
  }

  Future<void> selectAndUploadFile(context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await field.storage.uploadFile(
        doc: doc,
        file: pickedFile,
        fileFieldName: field.name,
        onUpload: docScreen.refresh,
      );
    }
  }

  Future<void> deleteFile(context) async {
    await field.storage.deleteFile(doc: doc, fileFieldName: field.name);
    docScreen.refresh();
  }

  @override
  readOnlyBuilder(context) {
    if (field.fileExists(doc) == false) return const Text('No File');
    return SQButton('Download', onPressed: openFileUrl);
  }

  @override
  fieldBuilder(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(field.name),
          if (field.fileExists(doc))
            SQButton('Download', onPressed: openFileUrl)
          else
            const Text('File not set'),
          SQButton("${field.fileExists(doc) ? 'Edit' : 'Upload'} File",
              onPressed: () async => selectAndUploadFile(context)),
          if (field.fileExists(doc))
            IconButton(
                onPressed: () async => deleteFile(context),
                icon: const Icon(Icons.delete))
        ],
      );
}
