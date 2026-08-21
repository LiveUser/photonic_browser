import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:photonic_browser/widgets.dart';

class FullImageViewer extends StatelessWidget {
  const FullImageViewer({
    super.key,
    required this.file,
  });
  final File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: Column(
          spacing: 10,
          children: [
            Expanded(
              child: Image.file(file),
            ),
            GestureDetector(
              onTap: (){
                //Save file
                String filePath = file.path;
                filePath =  filePath.replaceAll("\\", "/");
                String fileName = filePath.substring(filePath.lastIndexOf("/") + 1);
                Uint8List bytes = file.readAsBytesSync();
                FilePicker.saveFile(
                  fileName: fileName, 
                  bytes: bytes,
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                color: Colors.deepPurple,
                child: Text(
                  "Download",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}