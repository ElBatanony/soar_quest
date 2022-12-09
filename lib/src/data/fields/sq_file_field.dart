import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../storage/firebase_file_storage.dart';
import '../../storage/sq_file_storage.dart';
import '../../ui/sq_button.dart';
import '../sq_doc.dart';
import 'sq_string_field.dart';

class SQFileField extends SQStringField {
  SQFileField(super.name, {super.defaultValue, SQFileStorage? storage}) {
    this.storage = storage ?? FirebaseFileStorage();
  }

  late SQFileStorage storage;

  bool get fileExists => value != null;

  String? get downloadUrl => value;

  @override
  formField(docScreenState) => SQFileFormField(this, docScreenState);
}

class SQFileFormField<FileField extends SQFileField>
    extends SQFormField<String, FileField> {
  const SQFileFormField(super.field, super.docScreenState);

  Future<void> openFileUrl() async {
    if (field.downloadUrl == null)
      throw Exception('Download URL for ${field.name} is null');
    if (!await launchUrl(Uri.parse(field.downloadUrl!),
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
        field: field,
        onUpload: onChanged,
      );
    }
  }

  Future<void> deleteFile(context) async {
    await field.storage.deleteFile(doc: doc, field: field);
    onChanged();
  }

  @override
  Widget fieldBuilder(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(field.name),
          if (field.fileExists)
            SQButton('Download', onPressed: openFileUrl)
          else
            const Text('File not set'),
          SQButton("${field.fileExists ? 'Edit' : 'Upload'} File",
              onPressed: () async => selectAndUploadFile(context)),
          if (field.fileExists)
            IconButton(
                onPressed: () async => deleteFile(context),
                icon: const Icon(Icons.delete))
        ],
      );
}