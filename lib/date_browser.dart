import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photonic_browser/functions.dart';
import 'package:photonic_browser/widgets.dart';
import 'dart:io';


class DateBrowser extends StatefulWidget {
  const DateBrowser({
    super.key,
    required this.photosDirectory,
  });
  final String photosDirectory;

  @override
  State<DateBrowser> createState() => _DateBrowserState();
}

class _DateBrowserState extends State<DateBrowser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: FutureBuilder(
          future: compute(getItemsSortedByDate, Directory(widget.photosDirectory)), 
          builder: (context,snapshot){
            if(snapshot.hasError){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  Text(
                    snapshot.error.toString(),
                  ),
                  GestureDetector(
                    onTap: ()async{
                      setState(() {
                        
                      });
                    },
                    child: Container(
                      color: Colors.deepPurple,
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Retry",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }else if(snapshot.connectionState == ConnectionState.done){
              return Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: widgetizeImages(snapshot.data as List<PhotonicItem>),
                ),
              );
            }else{
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}