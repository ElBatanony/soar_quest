import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/fields/sq_string_field.dart';
import '../data/sq_doc.dart';
import '../ui/sq_button.dart';
import 'firebase_file_storage.dart';
import 'sq_file_storage.dart';

class SQFileField extends SQStringField {
  SQFileField(super.name, {super.value, SQFileStorage? storage}) {
    this.storage = storage ?? FirebaseFileStorage();
  }

  late SQFileStorage storage;

  bool get fileExists => value != null;

  String? get downloadUrl => value;

  @override
  SQFileField copy() => SQFileField(name, value: value, storage: storage);

  @override
  formField(SQDoc doc, {VoidCallback? onChanged}) =>
      SQFileFormField(this, doc, onChanged: onChanged);
}

class SQFileFormField<FileField extends SQFileField>
    extends SQFormField<FileField> {
  const SQFileFormField(super.field, super.doc, {super.onChanged});

  Future<void> openFileUrl() async {
    if (field.downloadUrl == null)
      throw Exception('Download URL for ${field.name} is null');
    if (!await launchUrl(Uri.parse(field.downloadUrl!),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch ${field.downloadUrl}');
    }
  }

  Future<void> selectAndUploadFile(SQFormFieldState formFieldState) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await field.storage.uploadFile(
          doc: doc,
          file: pickedFile,
          field: field,
          onUpload: () => formFieldState.onChanged());
    }
  }

  Future<void> deleteFile(SQFormFieldState formFieldState) async {
    await field.storage.deleteFile(doc: doc, field: field);
    formFieldState.onChanged();
  }

  @override
  Widget fieldBuilder(formFieldState) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(field.name),
          if (field.fileExists)
            SQButton('Download', onPressed: openFileUrl)
          else
            const Text('File not set'),
          SQButton("${field.fileExists ? 'Edit' : 'Upload'} File",
              onPressed: () async => selectAndUploadFile(formFieldState)),
          if (field.fileExists)
            IconButton(
                onPressed: () async => deleteFile(formFieldState),
                icon: const Icon(Icons.delete))
        ],
      );
}
