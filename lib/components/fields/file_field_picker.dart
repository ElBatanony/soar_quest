import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/buttons/sq_button.dart';
import '../../data/db.dart';
import '../../data/types.dart';

class FileFieldPicker extends StatefulWidget {
  final SQFileField fileField;
  final Function updateCallback;
  final SQDoc doc;
  final SQFileStorage storage;

  const FileFieldPicker(
      {required this.fileField,
      required this.updateCallback,
      required this.doc,
      required this.storage,
      super.key});

  @override
  State<FileFieldPicker> createState() => _FileFieldPickerState();
}

class _FileFieldPickerState extends State<FileFieldPicker> {
  bool fileExists = false;

  downloadFileFromUrl() async {
    final fileUrl = await widget.storage.getFileDownloadURL(widget.doc);
    final url = Uri.parse(fileUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $fileUrl';
    }
  }

  refreshFileExists() {
    setState(() {
      fileExists = widget.fileField.value.exists;
    });
  }

  selectAndUploadFile() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await widget.storage.uploadFile(
          doc: widget.doc,
          file: pickedFile,
          onUpload: () {
            refreshFileExists();
            widget.updateCallback();
          });
    }
  }

  deleteFile() async {
    await widget.storage.deleteFile(doc: widget.doc);
    refreshFileExists();
    widget.updateCallback();
  }

  @override
  void initState() {
    refreshFileExists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.fileField.name),
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
