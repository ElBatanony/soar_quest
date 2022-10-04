import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../db/sq_doc.dart';
import '../db/types/sq_file.dart';
import '../ui/sq_button.dart';

export '../db/types/sq_file.dart';

class SQFileField extends SQDocField<SQFile> {
  SQFileField(super.name, {super.value});

  @override
  SQFileField copy() {
    return SQFileField(name, value: value);
  }

  @override
  Type get type => SQFile;

  @override
  SQFile? parse(source) {
    return SQFile.parse(source);
  }

  @override
  SQFile get value => super.value ?? SQFile(fieldName: name, exists: false);

  SQFile get sqFile => value;

  @override
  collectField() {
    return {"exists": value.exists, "fieldName": name};
  }

  @override
  DocFormField formField({Function? onChanged, SQDoc? doc}) {
    return _SQFileFormField(this, onChanged: onChanged, doc: doc);
  }
}

class _SQFileFormField extends DocFormField<SQFileField> {
  const _SQFileFormField(super.field, {super.onChanged, required super.doc});

  @override
  createState() => _SQFileFormFieldState();
}

class _SQFileFormFieldState extends DocFormFieldState<SQFileField> {
  bool fileExists = false;
  late SQFileStorage storage = FirebaseFileStorage(field.value);

  downloadFileFromUrl() async {
    final fileUrl = await storage.getFileDownloadURL(doc!);
    final url = Uri.parse(fileUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $fileUrl';
    }
  }

  refreshFileExists() {
    setState(() {
      fileExists = field.value.exists;
    });
  }

  selectAndUploadFile() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await storage.uploadFile(
          doc: doc!,
          file: pickedFile,
          onUpload: () {
            refreshFileExists();
            onChanged();
          });
    }
  }

  deleteFile() async {
    await storage.deleteFile(doc: doc!);
    refreshFileExists();
    onChanged();
  }

  @override
  void initState() {
    refreshFileExists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (doc == null) return Text("No doc to upload file to");

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(field.name),
        fileExists
            ? SQButton("Download", onPressed: downloadFileFromUrl)
            : Text("File not set"),
        SQButton("${fileExists ? 'Edit' : 'Upload'} File",
            onPressed: selectAndUploadFile),
        if (fileExists)
          IconButton(onPressed: deleteFile, icon: Icon(Icons.delete))
      ],
    );
  }
}
