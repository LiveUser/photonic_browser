// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:photonic_browser/date_browser.dart';
import 'package:photonic_browser/widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photonic Browser',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: Center(
          child: GestureDetector(
            onTap: ()async{
              String? photosDirectory = await FilePicker.getDirectoryPath();
              if(photosDirectory != null){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => DateBrowser(photosDirectory: photosDirectory),
                ));
              }
            },
            child: Container(
              color: Colors.deepPurple,
              padding: EdgeInsets.all(20),
              child: Text(
                "Select folder containing images",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}