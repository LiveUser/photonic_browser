import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photonic_browser/functions.dart';
import 'package:photonic_browser/widgets.dart';
import 'package:map/map.dart';
import 'package:latlng/latlng.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:location/location.dart';


class LocationBrowser extends StatefulWidget {
  const LocationBrowser({
    super.key,
    required this.photosDirectory,
  });
  final String photosDirectory;
  @override
  State<LocationBrowser> createState() => _LocationBrowserState();
}

class _LocationBrowserState extends State<LocationBrowser> {
  MapController mapController = MapController(
    location: LatLng.degree(18.2849695, -66.3490417),
    zoom: 9,
  );
  GalleryUpdater galleryUpdater = GalleryUpdater();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        onPressed: ()async{
          Location location = Location();
          bool serviceEnabled;
          PermissionStatus permissionGranted;
          LocationData locationData;
          serviceEnabled = await location.serviceEnabled();
          if (!serviceEnabled) {
            serviceEnabled = await location.requestService();
            if (!serviceEnabled) {
              return;
            }
          }

          permissionGranted = await location.hasPermission();
          if (permissionGranted == PermissionStatus.denied) {
            permissionGranted = await location.requestPermission();
            if (permissionGranted != PermissionStatus.granted) {
              return;
            }
          }

          locationData = await location.getLocation();
          //print("Location: ${locationData.latitude},${locationData.longitude}");
          mapController.center = LatLng.degree(locationData.latitude, locationData.longitude);
          setState(() {
            
          });
        },
        child: Icon(
          Icons.my_location,
        ),
      ),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: MapView(
                mapController: mapController,
                galleryUpdater: galleryUpdater,
              ),
            ),
            Expanded(
              child: Gallery(
                photosDirectory: widget.photosDirectory,
                mapController: mapController,
                galleryUpdater: galleryUpdater,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MapView extends StatefulWidget {
  const MapView({
    super.key,
    required this.mapController,
    required this.galleryUpdater,
  });
  final MapController mapController;
  final GalleryUpdater galleryUpdater;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  double dragSensitivity = 0.01;
  double zoom = 0;
  @override
  void initState(){
    super.initState();
    zoom = widget.mapController.zoom;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Expanded(
          child: GestureDetector(
            onScaleUpdate: (details){
              // Handles dragging to pan
              double newLat = widget.mapController.center.latitude.degrees + details.focalPointDelta.dy * dragSensitivity / widget.mapController.zoom;
              double newLon = widget.mapController.center.longitude.degrees - details.focalPointDelta.dx * dragSensitivity / widget.mapController.zoom;
              widget.mapController.center = LatLng.degree(newLat, newLon);
              setState(() {
          
              });
            },
            onScaleEnd: (details){
              widget.galleryUpdater.update();
            },
            child: Stack(
              children: [
                MapLayout(
                  controller: widget.mapController, 
                  builder: (context,transformer){
                    return TileLayer(
                      builder: (context, x, y, z) {            
                        String url = "https://tile.openstreetmap.org/$z/$x/$y.png";
                        return CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                        );
                      },
                    );
                  },
                ),
                Center(
                  child: Icon(
                    Icons.center_focus_weak,
                    color: Colors.deepPurple,
                    size: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
        Slider(
          value: zoom, 
          min: 0,
          max: 19,
          onChanged: (newZoom){
            setState(() {
              zoom = newZoom;
              widget.mapController.zoom = newZoom;
            });
          },
          onChangeEnd: (newZoom){
            widget.galleryUpdater.update();
          },
        ),
      ],
    );
  }
}
class Gallery extends StatefulWidget {
  const Gallery({
    super.key,
    required this.photosDirectory,
    required this.mapController,
    required this.galleryUpdater,
  });
  final String photosDirectory;
  final MapController mapController;
  final GalleryUpdater galleryUpdater;

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {

  @override
  void initState(){
    super.initState();
    widget.galleryUpdater.addListener((){
      setState(() {
        
      });
    });
  }
  @override
  void dispose(){
    super.dispose();
    widget.galleryUpdater.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder(
        future: compute(getNearestItems, LocationSortSettings(
            photosDirectory: Directory(
              widget.photosDirectory,
            ), 
            latitude: widget.mapController.center.latitude.degrees, 
            longitude: widget.mapController.center.longitude.degrees,
          )
        ), 
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
    );
  }
}
class GalleryUpdater with ChangeNotifier{
  void update(){
    notifyListeners();
  }
}