import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pixer/pixer.dart';
import 'functions.dart';


AppBar appBar(){
  return AppBar(
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

  Future<Uint8List> genThumbnail()async{
    try{
      Uint8List bytes = await item.file.readAsBytes();
      Pixer pixer = Pixer.fromMemory(bytes);
      pixer = pixer.resize(100, 100);
      Uint8List thumbnail = pixer.encode(const PixerPngEncoder());
      return thumbnail;
    }catch(error){
      Uint8List bytes = await item.file.readAsBytes();
      return bytes;
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: genThumbnail(), 
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return Image.memory(
            snapshot.data as Uint8List,
            width: 150,
          );
        }else{
          return Icon(
            Icons.image,
            weight: 150,
          );
        }
      },
    );
  }
}