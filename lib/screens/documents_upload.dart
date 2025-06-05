import 'package:flutter/material.dart';
import '../Utils/widgets.dart';

class DocumentsUpload extends StatefulWidget {
  static const routeNmae = '/documents-upload';
  @override
  _DocumentsUploadState createState() => _DocumentsUploadState();
}

class _DocumentsUploadState extends State<DocumentsUpload> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          'Your Documents',
          style: TextStyle(color: Colors.black),
        )),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DocumentsUploader(),
        )));
  }
}
