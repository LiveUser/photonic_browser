import 'dart:io';
import 'package:exif_reader/exif_reader.dart';
import 'package:flutter/foundation.dart';
import 'package:pr_geo/pr_geo.dart';

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
int getMinInteger(){
  double maxNumber = double.maxFinite;
  int minNumber = -maxNumber.round();
  return minNumber;
}
Future<List<PhotonicItem>> getItemsSortedByDate(Directory photosDirectory)async{
  List<PhotonicItem> items = await fetchItems(photosDirectory);
  items.sort((a,b){
    return (b.dateTime?.millisecondsSinceEpoch ?? getMinInteger()).compareTo(a.dateTime?.microsecondsSinceEpoch ?? getMinInteger());
  });
  return items;
}
class LocationSortSettings{
  LocationSortSettings({
    required this.photosDirectory,
    required this.latitude,
    required this.longitude,
  });
  final Directory photosDirectory;
  final double latitude;
  final double longitude;
}
Future<List<PhotonicItem>> getNearestItems(LocationSortSettings settings)async{
  List<PhotonicItem> items = await fetchItems(settings.photosDirectory);
  items.sort((a,b){
    double aDistance = double.infinity;
    if(a.latitude != null && b.longitude!= null){
      GeoCoordinate point1 = GeoCoordinate(
        latitude: settings.latitude,
        longitude: settings.longitude,
      );
      GeoCoordinate point2 = GeoCoordinate(
        latitude: a.latitude!,
        longitude: a.longitude!,
      );
      aDistance = PR_Geo.distance(point1, point2);
    }
    double bDistance = double.infinity;
    if(b.latitude != null && b.longitude!= null){
      GeoCoordinate point1 = GeoCoordinate(
        latitude: settings.latitude,
        longitude: settings.longitude,
      );
      GeoCoordinate point2 = GeoCoordinate(
        latitude: b.latitude!,
        longitude: b.longitude!,
      );
      bDistance = PR_Geo.distance(point1, point2);
    }
    return bDistance.compareTo(aDistance);
  });
  return items;
}