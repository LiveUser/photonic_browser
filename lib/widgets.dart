import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photonic_browser/full_image_viewer.dart';
import 'package:pixer/pixer.dart';
import 'functions.dart';


AppBar appBar({
  List<Widget>? actions,
}){
  return AppBar(
    actions: actions,
    title: Text(
      "Photonic Browser",
      style: TextStyle(
        color: Colors.white,
        fontFamily: "BlackOpsOne",
      ),
    ),
    centerTitle: true,
    backgroundColor: Colors.deepPurple,
    foregroundColor: Colors.white,
  );
}
List<Widget> widgetizeImages(List<PhotonicItem> items){
  List<Widget> images = [];
  for(PhotonicItem item in items){
    images.add(ThumbnailViewer(
      item: item,
    ));
  }
  return images;
}
class ThumbnailViewer extends StatelessWidget {
  const ThumbnailViewer({
    super.key,
    required this.item,
  });
  final PhotonicItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => FullImageViewer(
            file: item.file,
          ),
        ));
      },
      child: Image.file(
        item.file,
        width: 150,
        cacheWidth: 150,
      ),
    );
  }
}