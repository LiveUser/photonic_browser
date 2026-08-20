import 'dart:io';
import 'package:exif_reader/exif_reader.dart';
import 'package:flutter/foundation.dart';

class PhotonicItem{
  PhotonicItem({
    required this.file,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
  });
  final File file;
  final DateTime? dateTime;
  final double? latitude;
  final double? longitude;
}
//Degrees, minutes, seconds to decimal degrees
double? _parseLocationAngle(List degreesMinutesSeconds){
  try{
    //Verify that it contains the correct length
    if(degreesMinutesSeconds.length != 3){
      //print(degreesMinutesSeconds);
      throw "Incorrect formatting or no location data";
    }
    //Parse to double if in the correct format
    double degrees = (degreesMinutesSeconds[0] as Ratio).numerator / (degreesMinutesSeconds[0] as Ratio).denominator;
    double minutes = (degreesMinutesSeconds[1] as Ratio).numerator / (degreesMinutesSeconds[1] as Ratio).denominator;
    double seconds = (degreesMinutesSeconds[2] as Ratio).numerator / (degreesMinutesSeconds[2] as Ratio).denominator;
    double decimalDegrees = degrees + (minutes / 60) + (seconds / 3600);
    return decimalDegrees;
  }catch(error){
    //print(error);
    return null;
  }
}
Future<List<PhotonicItem>> fetchItems(Directory photosDirectory)async{
  List<PhotonicItem> items = [];
  List<FileSystemEntity> folderContents = [];
  try{
    folderContents = await photosDirectory.list(recursive: true).toList();
  }catch(error){
    folderContents = [];
  }
  for(FileSystemEntity element in folderContents){
    if(element is File){
      Uint8List bytes = await element.readAsBytes();
      ExifData exif = await readExifFromBytes(bytes);
      if(exif.warnings.isEmpty){
        //print(exif.tags.entries.toList());
        IfdTag? dateTag = exif.tags['EXIF DateTimeOriginal'] ?? exif.tags['EXIF DateTimeDigitized'] ?? exif.tags['Image DateTime'];
        String dateAsString = dateTag?.printable ?? "";
        //Replace colons twice to meet the required standard
        dateAsString = dateAsString.replaceFirst(":", "-");
        dateAsString = dateAsString.replaceFirst(":", "-");
        DateTime? dateTime = DateTime.tryParse(dateAsString);
        double? latitude = _parseLocationAngle(exif.tags["GPS GPSLatitude"]?.values.toList() ?? []);
        double? longitude = _parseLocationAngle(exif.tags["GPS GPSLongitude"]?.values.toList() ?? []);
        if(latitude != null && exif.tags["GPS GPSLatitudeRef"]?.printable == "S"){
          latitude = -latitude;
        }
        if(longitude != null && exif.tags["GPS GPSLongitudeRef"]?.printable == "W"){
          longitude = -longitude;
        }
        items.add(PhotonicItem(
          file: element, 
          dateTime: dateTime, 
          latitude: latitude, 
          longitude: longitude,
        ));
      }
    }
  }
  return items;
}